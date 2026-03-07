import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/providers/hive_provider.dart';
import 'core/providers/shared_pres_provider.dart';
import 'core/services/hive/hive_service.dart';
import 'core/services/storage/storage_service.dart';
import 'core/services/storage/user_session_service.dart';

Future<void> main() async {
  // Keeps the native splash visible while initialization runs
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize HiveService
  final hiveService = HiveService();
  await hiveService.init();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs: prefs);

  // Remove native splash — hands off to your SplashScreen widget
  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      overrides: [
        hiveServiceProvider.overrideWithValue(hiveService),
        storageServiceProvider.overrideWithValue(storageService),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const NepalinkApp(),
    ),
  );
}
