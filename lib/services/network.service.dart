// lib/services/network.service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../design/design.dart';

/// Network connectivity service monitoring device internet state.
/// Displays offline banner until reconnected, then briefly shows green restored status for 3s.
class NetworkService extends GetxService {
  final bool autoInit;
  final RxBool isOnline = true.obs;
  final RxBool isBannerVisible = false.obs;
  final RxBool isRestored = false.obs;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _restoreTimer;
  bool _hasInitialCheck = false;

  NetworkService({this.autoInit = true});

  @override
  void onInit() {
    super.onInit();
    if (autoInit) {
      initConnectivity();
    }
  }

  @override
  void onClose() {
    _restoreTimer?.cancel();
    _subscription?.cancel();
    super.onClose();
  }

  /// Initializes connectivity listener and triggers initial check.
  void initConnectivity([Connectivity? customConnectivity]) {
    final connectivity = customConnectivity ?? Connectivity();
    try {
      _subscription = connectivity.onConnectivityChanged.listen(
        handleConnectivityChange,
        onError: (err) {
          debugPrint('[NetworkService] Connectivity stream error: $err');
        },
      );

      connectivity.checkConnectivity().then(
        (results) {
          handleInitialConnectivity(results);
        },
        onError: (err) {
          debugPrint('[NetworkService] Initial connectivity check error: $err');
          _hasInitialCheck = true;
        },
      );
    } catch (e) {
      debugPrint('[NetworkService] Native connectivity plugin unavailable: $e');
      _hasInitialCheck = true;
    }
  }

  /// Handles the initial connectivity check without triggering false 'restored' banners.
  void handleInitialConnectivity(List<ConnectivityResult> results) {
    _hasInitialCheck = true;
    final isConnected = _isResultConnected(results);
    isOnline.value = isConnected;

    if (!isConnected) {
      isBannerVisible.value = true;
      isRestored.value = false;
    } else {
      isBannerVisible.value = false;
      isRestored.value = false;
    }
  }

  /// Processes network status changes from the Connectivity stream.
  void handleConnectivityChange(List<ConnectivityResult> results) {
    if (!_hasInitialCheck) {
      handleInitialConnectivity(results);
      return;
    }

    final isConnected = _isResultConnected(results);

    if (!isConnected) {
      // Transition to OFFLINE
      _restoreTimer?.cancel();
      isOnline.value = false;
      isRestored.value = false;
      isBannerVisible.value = true;
    } else {
      // Transition to ONLINE
      if (!isOnline.value || isBannerVisible.value) {
        // Was previously offline: show green restored banner for 3 seconds
        isOnline.value = true;
        isRestored.value = true;
        isBannerVisible.value = true;

        _restoreTimer?.cancel();
        _restoreTimer = Timer(Design.timers.snackbar, () {
          isBannerVisible.value = false;
          isRestored.value = false;
        });
      } else {
        isOnline.value = true;
        isRestored.value = false;
        isBannerVisible.value = false;
      }
    }
  }

  bool _isResultConnected(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((r) => r != ConnectivityResult.none);
  }

  // ===== TEST / SIMULATION HELPERS =====

  /// Manually simulate going offline (useful for tests or demo mode).
  void simulateOffline() {
    _hasInitialCheck = true;
    handleConnectivityChange([ConnectivityResult.none]);
  }

  /// Manually simulate reconnecting (useful for tests or demo mode).
  void simulateOnline() {
    _hasInitialCheck = true;
    handleConnectivityChange([ConnectivityResult.wifi]);
  }

  /// Resets state and cancels any pending timers.
  void reset() {
    _restoreTimer?.cancel();
    _hasInitialCheck = false;
    isOnline.value = true;
    isBannerVisible.value = false;
    isRestored.value = false;
  }
}
