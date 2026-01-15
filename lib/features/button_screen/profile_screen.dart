import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/services/storage/user_session_service.dart';
import 'package:nepalink/features/auth/domain/usecases/logout_usecase.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final logoutUsecase = ref.read(logoutUsecaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(
                'assets/images/profile_placeholder.png',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Rabindra Bhattarai",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text("rabindra@example.com"),

            const SizedBox(height: 30),

            // Example buttons
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              onPressed: () {
                Navigator.pushNamed(context, '/editProfile');
              },
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text("Settings"),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.help_outline),
              label: const Text("Help & Support"),
              onPressed: () {
                Navigator.pushNamed(context, '/help');
              },
            ),
            const SizedBox(height: 12),

            // 🚪 Logout button
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final result = await ref.read(logoutUsecaseProvider)();
                result.fold(
                  (failure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(failure.message)));
                  },
                  (success) async {
                    if (success) {
                      final sessionService = ref.read(
                        userSessionServiceProvider,
                      );
                      print(
                        "Is logged in after logout? ${sessionService.isLoggedIn()}",
                      );
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
