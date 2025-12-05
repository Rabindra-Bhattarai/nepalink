import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String selectedRole = "Member";
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final extraController = TextEditingController();
  final locationController = TextEditingController();

  int experience = 0;

  void registerUser() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$selectedRole registered successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacementNamed(context, '/login');
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
            children: [
              _buildInfoCard(),
              const SizedBox(height: 25),
              _buildRoleSelector(),
              const SizedBox(height: 20),
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
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
      child: const Column(
        children: [
          Text(
            "Welcome to NepaLink",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Professional elderly care services that bridge the distance.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      children: [
        _roleTab("Member"),
        const SizedBox(width: 10),
        _roleTab("Caregiver"),
      ],
    );
  }

  Widget _roleTab(String role) {
    final isSelected = selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedRole = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF3C7EEF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              role,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            controller: fullNameController,
            hint: "Full Name",
            validator: (value) => value!.isEmpty ? "Enter your name" : null,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: emailController,
            hint: "Email",
            validator: (value) {
              if (value!.isEmpty) return "Enter email";
              if (!value.contains("@")) return "Enter valid email";
              return null;
            },
          ),
          const SizedBox(height: 12),
          if (selectedRole == "Member") ...[
            AppTextField(
              controller: extraController,
              hint: "Parent’s Name",
              validator: (value) => value!.isEmpty ? "Enter parent name" : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: locationController,
              hint: "Parent Location",
              validator: (value) => value!.isEmpty ? "Enter parent location" : null,
            ),
            const SizedBox(height: 12),
          ] else ...[
            TextFormField(
              controller: extraController,
              keyboardType: TextInputType.number,
              validator: (value) =>
              value!.isEmpty ? "Enter experience" : null,
              onChanged: (value) {
                setState(() {
                  experience = int.tryParse(value) ?? 0;
                });
              },
              decoration: InputDecoration(
                hintText: "Years of Experience",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 14),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (experience > 0) experience--;
                          extraController.text = experience.toString();
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          experience++;
                          extraController.text = experience.toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          AppTextField(
            controller: passwordController,
            hint: "Password",
            isPassword: true,
            validator: (value) {
              if (value!.isEmpty) return "Enter password";
              if (value.length < 6) return "Password too short";
              return null;
            },
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: confirmPasswordController,
            hint: "Confirm Password",
            isPassword: true,
            validator: (value) {
              if (value != passwordController.text) return "Passwords do not match";
              return null;
            },
          ),
          const SizedBox(height: 20),
          AppButton(
            text: "Create Account",
            onPressed: registerUser,
          ),
        ],
      ),
    );
  }
}
