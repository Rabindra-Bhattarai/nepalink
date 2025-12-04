import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';

class OnboardingPage2 extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingPage2({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Image.asset(
            'assets/images/onboarding2.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Hire Caregivers Easily",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Browse profiles, hire, and manage caregivers in one place.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 24),
        AppButton(text: "Next", onPressed: onNext),
      ],
    );
  }
}
