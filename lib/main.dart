import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/providers/hive_provider.dart';
import 'core/providers/shared_pres_provider.dart';
import 'core/services/hive/hive_service.dart';
import 'core/services/storage/storage_service.dart';
import 'core/services/storage/user_session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  Initialize HiveService
  final hiveService = HiveService();
  await hiveService.init();

  //  Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs: prefs);

  runApp(
    ProviderScope(
      overrides: [
        hiveServiceProvider.overrideWithValue(hiveService),
        storageServiceProvider.overrideWithValue(storageService),
        sharedPreferencesProvider.overrideWithValue(prefs), // ✅ added override
        // Chat providers don’t need overrides unless you want to swap implementations
      ],
      child: const NepalinkApp(),
    ),
  );
}
