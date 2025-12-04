import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';

class NepalinkApp extends StatelessWidget {
  const NepalinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nepalink',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3C7EEF)),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {'/splash': (_) => const SplashScreen()},
    );
  }
}
