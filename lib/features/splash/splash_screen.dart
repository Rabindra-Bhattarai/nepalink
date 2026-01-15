import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/services/storage/user_session_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final userSessionService = ref.read(userSessionServiceProvider);
    final isLoggedIn = userSessionService.isLoggedIn();

    if (isLoggedIn) {
      // ✅ Navigate to caregiver dashboard if logged in
      Navigator.pushReplacementNamed(context, 'caregiverDashboard');
    } else {
      // ✅ Navigate to login if not logged in
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;
    final maxLogoWidth = shortestSide < 600
        ? size.width * 0.75
        : size.width * 0.6;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxLogoWidth),
          child: AspectRatio(
            aspectRatio: 2000 / 383,
            child: Image.asset(
              'assets/images/nepalink.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
