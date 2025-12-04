import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;               // show/hide password
  String selectedRole = "Member";            // default selected role

  final _formKey = GlobalKey<FormState>();   // for form validation

  void loginUser() {
    if (_formKey.currentState!.validate()) {
      // All fields valid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logging in as $selectedRole..."),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to Home Screen after short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacementNamed(context, '/home');
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// TOP INFO CARD
              _buildInfoCard(),

              const SizedBox(height: 25),

              /// LOGIN CARD
              _buildLoginCard(context),
            ],
          ),
        ),
      ),
    );
  }

  /// ------------------------------
  /// LOGIN CARD UI
  /// ------------------------------
  Widget _buildLoginCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF9BB7FF),
            Color(0xFFB4CBFF),
          ],
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

            /// ROLE SELECTOR (SLIDING BUTTON)
            _roleSelector(),

            const SizedBox(height: 25),

            /// EMAIL FIELD
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

            /// PASSWORD FIELD (WITH HIDE/SHOW)
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

            /// SIGN IN BUTTON
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
                onPressed: loginUser,
                child: const Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// REGISTER NAVIGATION
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/register");
              },
              child: const Text(
                "Don’t have an account? Register",
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ------------------------------
  /// SLIDE ROLE SELECTOR
  /// ------------------------------
  Widget _roleSelector() {
    return Container(
      height: 45,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          /// Sliding background
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment:
            selectedRole == "Member" ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: (MediaQuery.of(context).size.width - 80) / 2,
              decoration: BoxDecoration(
                color: const Color(0xFF3C7EEF),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          Row(
            children: [
              _roleButton("Member"),
              _roleButton("Caregiver"),
            ],
          )
        ],
      ),
    );
  }

  /// Role buttons inside selector
  Widget _roleButton(String role) {
    final isSelected = selectedRole == role;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedRole = role;
          });
        },
        child: Center(
          child: Text(
            role,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// -----------------------------------------------------

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
          )
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

          _buildFeature(Icons.verified, "Verified Caregivers",
              "Background-checked professionals you can trust"),
          _buildFeature(Icons.location_on, "Real-Time Updates",
              "Track tasks, location and care activities live"),
          _buildFeature(Icons.chat, "Seamless Communication",
              "Instant messaging and alerts"),
        ],
      ),
    );
  }

  /// Feature rows
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
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
                Text(desc, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Input styling
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
    );
  }
}
