class TestUser {
  final String email;
  final String name;
  final String username;
  final String password;

  TestUser({
    required this.email,
    required this.name,
    required this.username,
    required this.password,
  });
}

class TestUsers {
  static int _userCounter = 0;

  static TestUser generate({String prefix = 'user'}) {
    _userCounter++;
    final uniqueId = '${DateTime.now().millisecondsSinceEpoch}_$_userCounter';
    final truncatedUsername = 'e2e_${prefix}_$uniqueId'.length > 25
        ? 'e2e_${prefix}_$uniqueId'.substring(0, 25)
        : 'e2e_${prefix}_$uniqueId';

    return TestUser(
      email: 'e2e-$prefix-$uniqueId@rexone.test',
      name: 'E2E $prefix $_userCounter',
      username: truncatedUsername,
      password: '123456',
    );
  }

  static final existing = TestUser(
    email: 'just@admin.com',
    name: 'Just Admin User',
    username: 'justadmin',
    password: '123456',
  );

  static final existingUnconfirmed = TestUser(
    email: 'e2e-existing-unconfirmed@rexone.test',
    name: 'E2E Unconfirmed',
    username: 'e2e_unconfirmed',
    password: '123456',
  );

  static final signup = TestUser(
    email: 'e2e-signup@rexone.test',
    name: 'E2E Signup',
    username: 'e2e_signup',
    password: '123456',
  );

  static final resetUser = TestUser(
    email: 'just@admin.com',
    name: 'Just Admin User',
    username: 'justadmin',
    password: '123456',
  );
}
