/// Mirrors web `src/AppRoutes.ts`.
class AppRoutes {
  AppRoutes._();

  static const client = _ClientRoutes();
  static const server = _ServerRoutes();
}

class _ClientRoutes {
  const _ClientRoutes();

  _PublicClientRoutes get public => const _PublicClientRoutes();
  _ProtectedClientRoutes get protected => const _ProtectedClientRoutes();
}

class _PublicClientRoutes {
  const _PublicClientRoutes();

  String get root => '/';
}

class _ProtectedClientRoutes {
  const _ProtectedClientRoutes();

  String get home => '/home';
  String get profile => '/profile';
}

class _ServerRoutes {
  const _ServerRoutes();

  _PublicServerRoutes get public => const _PublicServerRoutes();
  _ProtectedServerRoutes get protected => const _ProtectedServerRoutes();
}

class _PublicServerRoutes {
  const _PublicServerRoutes();

  String get signUp => '/signup';
  String get signInEmail => '/signin';
  String get signInToken => '/signin/token';
  String get signInGoogle => '/signin/google';
  String get signInGoogleComplete => '/signin/google/complete';
  String get sendEmailCode => '/confirmation/send_code';
  String get confirmCode => '/confirmation/confirm_code';
  String get forgotPassword => '/password/forgot';
  String get resetPassword => '/password/reset';
}

class _ProtectedServerRoutes {
  const _ProtectedServerRoutes();

  String get signOut => '/signout';
  String get peekUser => '/users/peek';
  String get getCurrentUser => '/users/current';
  String get uploadAsset => '/media/upload';
}
