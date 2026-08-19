enum EPeekedUserStatus {
  error, // API call failed
  exists, // User exists and is confirmed
  existsUnconfirmed, // User exists but not confirmed (incomplete onboarding)
  notExists, // User does not exist
}

enum EButtonType { primary, secondary, text, icon, google }


enum EWsEventType {
  paymentSuccess('payment_success'),
  subscriptionCreated('subscription_created'),
  subscriptionUpdated('subscription_updated'),
  paymentIntentSucceeded('payment_intent.succeeded'),
  paymentFailed('payment_failed'),
  paymentIntentPaymentFailed('payment_intent.payment_failed'),
  subscriptionCanceled('subscription_canceled'),
  subscriptionResumed('subscription_resumed'),

  welcome('welcome'),
  aiResponseReady('ai_response_ready'),
  aiResponseFailed('ai_response_failed'),

  unknown('unknown');

  final String value;
  const EWsEventType(this.value);

  factory EWsEventType.fromString(String value) {
    return EWsEventType.values.firstWhere(
          (e) => e.value == value,
      orElse: () => EWsEventType.unknown,
    );
  }
}

