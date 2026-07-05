import 'package:flutter/foundation.dart';

/// Mirrors web `src/contexts/LoadingContext.tsx`.
class LoadingContext extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    if (_isLoading == loading) return;
    _isLoading = loading;
    notifyListeners();
  }
}
