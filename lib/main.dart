import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'core/services/hive/hive_service.dart';
import 'core/services/storage/user_session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive (centralized in HiveService)
  await HiveService().init();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Override sharedPreferencesProvider with actual instance
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const NepalinkApp(),
    ),
  );
}
