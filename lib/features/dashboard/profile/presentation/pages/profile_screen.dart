// lib/features/dashboard/profile/presentation/pages/profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nepalink/core/providers/theme_provider.dart';
import 'package:nepalink/features/dashboard/profile/presentation/view_model/profile_view_model.dart';
import 'package:nepalink/features/dashboard/profile/domain/entities/profile_entity.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late ScaffoldMessengerState _messenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _messenger = ScaffoldMessenger.of(context);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(profileViewModelProvider.notifier).loadProfile(),
    );
  }

  void _showSnack(String message, {bool isError = false}) {
    _messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red[600] : Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 85,
    );
    if (picked == null) return;

    final success = await ref
        .read(profileViewModelProvider.notifier)
        .uploadProfilePicture(File(picked.path));

    _showSnack(
      success ? 'Profile picture updated!' : 'Failed to upload picture',
      isError: !success,
    );
  }

  void _openEditDialog(ProfileEntity profile) {
    final nameController = TextEditingController(text: profile.name);
    final phoneController = TextEditingController(text: profile.phone);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: _inputDecoration('Full Name', Icons.person_rounded),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: _inputDecoration('Phone', Icons.phone_rounded),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.length < 7 ? 'Enter a valid phone' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          Consumer(
            builder: (context, ref, _) {
              final isUpdating = ref.watch(
                profileViewModelProvider.select((s) => s.isUpdating),
              );
              return ElevatedButton(
                onPressed: isUpdating
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        Navigator.pop(ctx);
                        final success = await ref
                            .read(profileViewModelProvider.notifier)
                            .updateProfile(
                              name: nameController.text.trim(),
                              phone: phoneController.text.trim(),
                            );
                        _showSnack(
                          success
                              ? 'Profile updated!'
                              : 'Failed to update profile',
                          isError: !success,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isUpdating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save'),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ref
          .read(profileViewModelProvider.notifier)
          .logout();
      if (success && mounted) {
        // Navigate to login and clear all routes
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileViewModelProvider);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.profile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: Colors.red[300]),
            const SizedBox(height: 12),
            Text(
              state.errorMessage ?? 'Failed to load profile',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(profileViewModelProvider.notifier).loadProfile(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final profile = state.profile!;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          // ── Header with avatar ──────────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
            child: Column(
              children: [
                // Avatar
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.white,
                        backgroundImage: profile.imageUrl != null
                            ? NetworkImage(profile.imageUrl!)
                            : null,
                        child: profile.imageUrl == null
                            ? Text(
                                profile.name.isNotEmpty
                                    ? profile.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[600],
                                ),
                              )
                            : null,
                      ),
                    ),
                    // Camera button
                    GestureDetector(
                      onTap: state.isUpdating ? null : _pickAndUploadImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: state.isUpdating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                Icons.camera_alt_rounded,
                                size: 18,
                                color: Colors.blue[600],
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  profile.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    profile.role.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Info Cards ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Account Info'),
                const SizedBox(height: 12),
                _infoCard(profile),

                const SizedBox(height: 24),
                _sectionTitle('Settings'),
                const SizedBox(height: 12),
                _settingsCard(isDark),

                const SizedBox(height: 24),
                _sectionTitle('Account'),
                const SizedBox(height: 12),
                _accountCard(profile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
        color: Colors.grey,
      ),
    );
  }

  Widget _infoCard(ProfileEntity profile) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoRow(Icons.person_rounded, 'Name', profile.name, Colors.blue),
          _divider(),
          _infoRow(Icons.email_rounded, 'Email', profile.email, Colors.purple),
          _divider(),
          _infoRow(Icons.phone_rounded, 'Phone', profile.phone, Colors.green),
          _divider(),
          // Edit button
          ListTile(
            onTap: () => _openEditDialog(profile),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.edit_rounded,
                color: Colors.orange[600],
                size: 20,
              ),
            ),
            title: const Text(
              'Edit Profile',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Dark mode toggle
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: Colors.indigo[600],
                size: 20,
              ),
            ),
            title: const Text(
              'Dark Mode',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              isDark ? 'On' : 'Off',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            trailing: Switch.adaptive(
              value: isDark,
              activeColor: Colors.indigo[600],
              onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
            ),
          ),
          _divider(),
          // Notifications (placeholder)
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.notifications_rounded,
                color: Colors.teal[600],
                size: 20,
              ),
            ),
            title: const Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
            ),
            onTap: () {},
          ),
          _divider(),
          // Privacy (placeholder)
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.lock_rounded,
                color: Colors.green[600],
                size: 20,
              ),
            ),
            title: const Text(
              'Privacy & Security',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _accountCard(ProfileEntity profile) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Member since
          if (profile.createdAt != null) ...[
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.blue[600],
                  size: 20,
                ),
              ),
              title: const Text(
                'Member Since',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                _formatDate(profile.createdAt!),
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
            _divider(),
          ],
          // Logout
          ListTile(
            onTap: _confirmLogout,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.logout_rounded,
                color: Colors.red[600],
                size: 20,
              ),
            ),
            title: Text(
              'Log Out',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.red[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }

  Widget _divider() => Divider(
    height: 1,
    indent: 16,
    endIndent: 16,
    color: Colors.grey.withOpacity(0.15),
  );

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}
