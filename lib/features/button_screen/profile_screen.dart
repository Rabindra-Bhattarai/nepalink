import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/services/storage/user_session_service.dart';
import 'package:nepalink/features/auth/domain/usecases/logout_usecase.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        backgroundColor: const Color(0xFF3C7EEF),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/images/profile_placeholder.png',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Rabindra Bhattarai",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "rabindra@example.com",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 30),

            // Info cards
            _buildInfoCard(
              icon: Icons.favorite,
              title: "Health Records",
              subtitle: "View your medical history and reports",
              onTap: () => Navigator.pushNamed(context, '/healthRecords'),
            ),
            const SizedBox(height: 12),

            _buildInfoCard(
              icon: Icons.calendar_today,
              title: "Appointments",
              subtitle: "Manage upcoming visits and schedules",
              onTap: () => Navigator.pushNamed(context, '/appointments'),
            ),
            const SizedBox(height: 12),

            _buildInfoCard(
              icon: Icons.settings,
              title: "Settings",
              subtitle: "Manage preferences and notifications",
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
            const SizedBox(height: 12),

            _buildInfoCard(
              icon: Icons.help_outline,
              title: "Help & Support",
              subtitle: "Get assistance and FAQs",
              onTap: () => Navigator.pushNamed(context, '/help'),
            ),
            const SizedBox(height: 30),

            // 🚪 Logout button (unchanged logic)
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF3C7EEF), size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
