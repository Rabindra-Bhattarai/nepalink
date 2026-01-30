import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nepalink/core/services/storage/user_session_service.dart';
import 'package:nepalink/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nepalink/features/auth/domain/usecases/upload_profile_image_usecase.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  File? _profileImage;

  Future<void> _pickImage(BuildContext context) async {
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Permission denied")));
      }
      return;
    }

    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _profileImage = File(image.path));
    }
  }

  Future<void> _saveImage(BuildContext context) async {
    if (_profileImage == null) return;

    final userId = ref.read(userSessionServiceProvider).getCurrentUserId();
    if (userId != null) {
      final result = await ref
          .read(uploadProfileImageUsecaseProvider)
          .call(userId, _profileImage!);

      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Upload failed: ${failure.message}")),
            );
          }
        },
        (updatedUser) async {
          if (updatedUser.profilePic != null &&
              updatedUser.profilePic!.isNotEmpty) {
            await ref
                .read(userSessionServiceProvider)
                .updateProfilePic(updatedUser.profilePic!);
          }

          setState(() {
            _profileImage = null; // clear local file, reload from session
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile photo saved!")),
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionService = ref.read(userSessionServiceProvider);
    final savedPic = sessionService.getCurrentUserProfilePic();

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
            GestureDetector(
              onTap: () => _pickImage(context),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : (savedPic != null && savedPic.isNotEmpty
                          ? NetworkImage(
                              // "http://192.168.1.8:3000/uploads/$savedPic", //  fixed path
                              "http://localhost:3000/uploads/$savedPic", //  fixed path
                            )
                          : const AssetImage(
                                  'assets/images/profile_placeholder.png',
                                )
                                as ImageProvider),
              ),
            ),
            const SizedBox(height: 12),

            if (_profileImage != null)
              ElevatedButton(
                onPressed: () => _saveImage(context),
                child: const Text("Save"),
              ),

            const SizedBox(height: 16),
            Text(
              sessionService.getCurrentUserName() ?? "Unknown User",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              sessionService.getCurrentUserEmail() ?? "",
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 30),

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
                    if (mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(failure.message)));
                    }
                  },
                  (success) async {
                    if (success) {
                      await ref.read(userSessionServiceProvider).clearSession();
                      if (mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      }
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

Widget _buildInfoCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      leading: Icon(icon, color: const Color(0xFF3C7EEF)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    ),
  );
}
