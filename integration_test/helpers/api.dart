import 'dart:convert';
import 'dart:io';

import '../data/users.dart';

class ApiHelper {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else {
      return 'http://localhost:3000';
    }
  }

  /// Register user via standard POST /signup route
  static Future<void> registerUser(TestUser user) async {
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse('$baseUrl/signup'));
    request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    request.headers.set('X-Platform', 'mobile');
    request.add(utf8.encode(jsonEncode({
      'user': {
        'email': user.email,
        'name': user.name,
        'username': user.username,
        'password': user.password,
        'password_confirmation': user.password,
      }
    })));
    await request.close();
    client.close();
  }

  static Future<void> createUser(TestUser user) async {
    await registerUser(user);
  }

  static Future<void> cleanupUser(String email) async {
    // Best-effort cleanup using standard routes
  }

  static Future<void> cleanupAllTestUsers() async {
    // Best-effort cleanup
  }
}
