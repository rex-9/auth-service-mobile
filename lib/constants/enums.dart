enum EPeekedUserStatus {
  error, // API call failed
  exists, // User exists and is confirmed
  existsUnconfirmed, // User exists but not confirmed (incomplete onboarding)
  notExists, // User does not exist
}

enum EButtonType { primary, secondary, text, icon, google }
