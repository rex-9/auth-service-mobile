import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../reducers/google_sso_reducer.dart';
import '../services/storage_service.dart';

/// Mirrors web `src/contexts/AuthContext.tsx`.
///
/// Token and current user persist across launches (SharedPreferences here,
/// Jotai `atomWithStorage` on web).
class AuthContext extends ChangeNotifier {
  AuthContext(this._storage)
      : _token = _storage.getString(_tokenKey),
        _currentUser = _readPersistedUser(_storage);

  static const _tokenKey = 'token';
  static const _userKey = 'user';

  final StorageService _storage;

  String? _token;
  User? _currentUser;
  GoogleSsoState _googleSsoState = initialGoogleSsoState;

  /// Set when the backend replaced this session with a newer sign in;
  /// surfaced by the auth dialog (mirrors the `session_message` URL param).
  String? sessionMessage;

  bool get isAuthenticated => _token != null && _token!.isNotEmpty;
  String? get token => _token;
  User? get currentUser => _currentUser;
  GoogleSsoState get googleSsoState => _googleSsoState;

  static User? _readPersistedUser(StorageService storage) {
    final json = storage.getJson(_userKey);
    return json == null ? null : User.fromJson(json);
  }

  void setCurrentUser(User? user) {
    _currentUser = user;
    if (user == null) {
      _storage.remove(_userKey);
    } else {
      _storage.setJson(_userKey, user.toJson());
    }
    notifyListeners();
  }

  void signin(String token, User user) {
    _token = token;
    _currentUser = user;
    _storage.setString(_tokenKey, token);
    _storage.setJson(_userKey, user.toJson());
    dispatchGoogleSsoAction(const VerifyGoogleSuccessAuthenticated());
  }

  void signout() {
    _token = null;
    _currentUser = null;
    _storage.remove(_tokenKey);
    _storage.remove(_userKey);
    dispatchGoogleSsoAction(const GoogleSsoReset());
  }

  void dispatchGoogleSsoAction(GoogleSsoAction action) {
    _googleSsoState = googleSsoStateReducer(_googleSsoState, action);
    notifyListeners();
  }

  void setSessionMessage(String? message) {
    sessionMessage = message;
    notifyListeners();
  }
}
