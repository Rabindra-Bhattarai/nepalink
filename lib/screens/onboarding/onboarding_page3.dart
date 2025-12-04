import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';

class OnboardingPage3 extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingPage3({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Image.asset(
            'assets/images/onboarding3.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Track & Communicate",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Assign tasks, share location, and chat securely with your caregivers.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 24),
        AppButton(text: "Start Now", onPressed: onNext),
      ],
    );
  }
}
