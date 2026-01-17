import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/features/auth/presentation/view_model/login_viewmodel.dart';
import 'package:nepalink/features/auth/presentation/state/login_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  void loginUser() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(loginViewModelProvider.notifier)
          .login(emailController.text.trim(), passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);

    ref.listen<LoginState>(loginViewModelProvider, (prev, next) {
      if (next.status == LoginStatus.success) {
        Navigator.pushReplacementNamed(context, '/caregiverDashboard');
      } else if (next.status == LoginStatus.failure &&
          next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 25),
              _buildLoginCard(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context, LoginState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9BB7FF), Color(0xFFB4CBFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              "Welcome to NepaLink",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Sign in to your account",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration("Email"),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your email";
                }
                if (!value.contains("@") || !value.contains(".")) {
                  return "Enter a valid email";
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: _inputDecoration("Password").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your password";
                }
                if (value.length < 6) {
                  return "Password must be at least 6 characters";
                }
                return null;
              },
            ),
            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3C7EEF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: state.status == LoginStatus.loading
                    ? null
                    : loginUser,
                child: state.status == LoginStatus.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),

            const SizedBox(height: 15),

            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/register"),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                  children: [
                    const TextSpan(text: "Don't have an account? "),
                    const TextSpan(
                      text: "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3C7EEF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            spreadRadius: 1,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset("assets/images/nepalink.png", height: 50),
          const SizedBox(height: 10),
          const Text(
            "Professional elderly care services that bridge the distance. Stay connected, ensure quality care, and peace of mind knowing your loved ones are in good hands.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 20),
          _buildFeature(
            Icons.verified,
            "Verified Caregivers",
            "Background-checked professionals you can trust",
          ),
          _buildFeature(
            Icons.location_on,
            "Real-Time Updates",
            "Track tasks, location and care activities live",
          ),
          _buildFeature(
            Icons.chat,
            "Seamless Communication",
            "Instant messaging and alerts",
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF3C7EEF), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(desc, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF3C7EEF), width: 1.5),
      ),
    );
  }
}
