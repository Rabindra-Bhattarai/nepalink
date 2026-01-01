import 'package:flutter/material.dart';
import 'package:nepalink/features/dashboard/presentation/pages/caregiver_dashboard.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/register_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
// import 'screens/dashboard/caregiver/caregiver_dashboard.dart';
//import 'screens/Navigation/button_navigation_screen.dart';
// import 'screens/home/home_screen.dart';

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
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        'caregiverDashboard': (_) => const CaregiverDashboard(),
        //'/navigation':(_)=>const ButtonNavigationScreen()
        // '/home': (_) => const HomeScreen(),
      },
    );
  }
}
