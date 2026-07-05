import 'package:flutter/material.dart';

import 'app.dart';
import 'services/services.dart';

/// Mirrors web `src/main.tsx`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await StorageService.init();
  runApp(App(storage: storage));
}
