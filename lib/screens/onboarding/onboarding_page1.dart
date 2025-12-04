import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';

class OnboardingPage1 extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingPage1({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Image.asset(
            'assets/images/onboarding1.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Welcome to NepaLink!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Your trusted platform for hiring caregivers and managing tasks.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 24),
        AppButton(text: "Get Started", onPressed: onNext),
      ],
    );
  }
}
