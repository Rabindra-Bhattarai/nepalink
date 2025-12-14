import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/dashboard/member/member_dashboard.dart';
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
        'memberDashboard': (_) => const MemberDashboard(),
        //'/navigation':(_)=>const ButtonNavigationScreen()
        // '/home': (_) => const HomeScreen(),
      },
    );
  }
}
