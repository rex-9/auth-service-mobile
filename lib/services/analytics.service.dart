// lib/services/analytics.service.dart

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rexone_mobile/constants/constants.dart';

class AnalyticsService extends GetxService {
  late FirebaseAnalytics _analytics;
  late FirebaseAnalyticsObserver _observer;

  FirebaseAnalytics get analytics => _analytics;
  FirebaseAnalyticsObserver get observer => _observer;

  @override
  void onInit() {
    super.onInit();
    _initAnalytics();
  }

  Future<void> _initAnalytics() async {
    try {
      _analytics = FirebaseAnalytics.instance;
      _observer = FirebaseAnalyticsObserver(analytics: _analytics);
      debugPrint('✅ Analytics initialized');
    } catch (e) {
      debugPrint('❌ Analytics init failed: $e');
    }
  }

  // ===== SCREEN TRACKING =====
  void logScreenView(String screenName, {String? screenClass}) {
    try {
      _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
    } catch (e) {
      debugPrint('❌ Analytics logScreenView failed: $e');
    }
  }

  // ===== USER PROPERTIES =====
  void setUserId(String userId) {
    try {
      _analytics.setUserId(id: userId);
    } catch (e) {
      debugPrint('❌ Analytics setUserId failed: $e');
    }
  }

  void setUserProperty(String name, String value) {
    try {
      _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      debugPrint('❌ Analytics setUserProperty failed: $e');
    }
  }

  void clearUserId() {
    try {
      _analytics.setUserId(id: null);
    } catch (e) {
      debugPrint('❌ Analytics clearUserId failed: $e');
    }
  }

  // ===== EVENTS =====
  void logEvent(String name, {Map<String, Object>? parameters}) {
    try {
      _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      debugPrint('❌ Analytics logEvent failed: $e');
    }
  }

  // ===== AUTH EVENTS =====
  void logSignUp({String? method}) {
    logEvent(
      Constants.analytics.eventSignUp,
      parameters: {
        Constants.analytics.paramMethod:
            method ?? Constants.analytics.methodEmail,
      },
    );
  }

  void logSignIn({String? method}) {
    logEvent(
      Constants.analytics.eventSignIn,
      parameters: {
        Constants.analytics.paramMethod:
            method ?? Constants.analytics.methodEmail,
      },
    );
  }

  void logSignOut() {
    logEvent(Constants.analytics.eventSignOut);
  }

  void logPasswordResetRequested() {
    logEvent(Constants.analytics.eventPasswordReset);
  }

  // ===== ONBOARDING EVENTS =====
  void logOnboardingStarted() {
    logEvent(Constants.analytics.eventOnboardingStarted);
  }

  void logOnboardingCompleted() {
    logEvent(Constants.analytics.eventOnboardingCompleted);
  }

  void logEmailVerified() {
    logEvent(Constants.analytics.eventEmailVerified);
  }

  // ===== APP EVENTS =====
  void logAppOpen() {
    logEvent(Constants.analytics.eventAppOpen);
  }

  void logAppBackground() {
    logEvent(Constants.analytics.eventAppBackground);
  }

  void logError(String error, {String? context}) {
    logEvent(
      Constants.analytics.eventAppError,
      parameters: {
        Constants.analytics.paramError: error,
        Constants.analytics.paramContext: context ?? 'unknown',
      },
    );
  }

  // ===== PUSH NOTIFICATION =====
  void logPushReceived(Map<String, Object> data) {
    logEvent(Constants.analytics.eventPushReceived, parameters: data);
  }

  void logPushOpened(Map<String, dynamic> data) {
    logEvent(
      Constants.analytics.eventPushOpened,
      parameters: data.cast<String, Object>(),
    );
  }

  // ===== PERFORMANCE =====
  void logPerformance(String metric, {Object? value}) {
    logEvent(
      Constants.analytics.eventPerformance,
      parameters: {
        Constants.analytics.paramMetric: metric,
        Constants.analytics.paramValue: value ?? '',
      },
    );
  }
}
