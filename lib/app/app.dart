import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/features/Navigation/button_navigation_screen.dart';
// import 'package:nepalink/features/dashboard/presentation/pages/caregiver_dashboard.dart';

import '../features/splash/splash_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/register_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/dashboard/booking/presentation/pages/booking_page.dart';

class NepalinkApp extends ConsumerWidget {
  const NepalinkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nepalink',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3C7EEF)),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/dashboard': (_) => const ButtonNavigationScreen(),
        '/booking': (_) => const BookingPage(),
      },
    );
  }
}
