import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nepalink/core/providers/theme_provider.dart';
import 'package:nepalink/core/services/biometric/biometric_service.dart';
import 'package:nepalink/features/dashboard/profile/presentation/view_model/profile_view_model.dart';
import 'package:nepalink/features/dashboard/profile/domain/entities/profile_entity.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late ScaffoldMessengerState _messenger;

  // ── Biometric state ──
  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;
  bool _isBiometricLoading = false;

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
    _loadBiometricStatus();
  }

  Future<void> _loadBiometricStatus() async {
    final biometricService = ref.read(biometricServiceProvider);
    final isAvailable = await biometricService.isAvailable();
    final isEnabled = await biometricService.isBiometricEnabled();
    if (mounted) {
      setState(() {
        _isBiometricAvailable = isAvailable;
        _isBiometricEnabled = isEnabled;
      });
    }
  }

  Future<void> _toggleBiometric(bool enable) async {
    final biometricService = ref.read(biometricServiceProvider);

    if (enable) {
      setState(() => _isBiometricLoading = true);
      final result = await biometricService.enableBiometric();
      if (mounted) {
        setState(() {
          _isBiometricEnabled = result.success;
          _isBiometricLoading = false;
        });
        if (result.success) {
          _showSnack('Fingerprint login enabled successfully!');
        } else {
          _showSnack(
            result.errorMessage ?? 'Fingerprint setup failed. Try again.',
            isError: true,
          );
        }
      }
    } else {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Disable Fingerprint Login',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to disable fingerprint login? You will need to use your email and password to sign in.',
          ),
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
              child: const Text('Disable'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        await biometricService.disableBiometric();
        if (mounted) {
          setState(() => _isBiometricEnabled = false);
          _showSnack('Fingerprint login disabled.');
        }
      }
    }
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

  // ── Permission helper ────────────────────────────────────────────────────
  /// Returns true if we have (or just obtained) the media/storage permission.
  /// On Android 13+ uses READ_MEDIA_IMAGES; on older versions READ_EXTERNAL_STORAGE.
  /// If permanently denied, opens app settings so the user can fix it manually.
  Future<bool> _requestPhotoPermission() async {
    // Android 13+ uses granular media permissions
    final Permission permission = Platform.isAndroid
        ? (await _isAndroid13OrAbove()
              ? Permission
                    .photos // maps to READ_MEDIA_IMAGES on 13+
              : Permission.storage) // READ_EXTERNAL_STORAGE on <13
        : Permission.photos; // iOS Photos

    final status = await permission.status;

    // Already granted — nothing to do
    if (status.isGranted) return true;

    // Not yet asked or previously denied (but not permanently) — ask now
    if (status.isDenied) {
      final result = await permission.request();
      if (result.isGranted) return true;

      // User denied — show a gentle explanation snackbar
      if (mounted) {
        _showSnack(
          'Photo access is needed to update your profile picture.',
          isError: true,
        );
      }
      return false;
    }

    // Permanently denied — the only way forward is app settings
    if (status.isPermanentlyDenied) {
      if (mounted) await _showGoToSettingsDialog();
      return false;
    }

    return false;
  }

  /// Shows a dialog explaining why the permission is needed and
  /// offers a direct "Open Settings" button.
  Future<void> _showGoToSettingsDialog() async {
    final goToSettings = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Photo Permission Required',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'You have permanently denied photo access.\n\n'
          'To update your profile picture, please enable "Photos" or '
          '"Storage" permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: const Icon(Icons.settings_rounded, size: 18),
            label: const Text('Open Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );

    if (goToSettings == true) {
      await openAppSettings(); // from permission_handler
    }
  }

  /// Detects Android 13+ (API 33) by checking if READ_MEDIA_IMAGES exists.
  Future<bool> _isAndroid13OrAbove() async {
    // permission_handler exposes .photos on Android 13+ as READ_MEDIA_IMAGES.
    // On older versions it resolves to READ_EXTERNAL_STORAGE.
    // A simple way to check: if photos permission status is not restricted
    // it means the OS understands READ_MEDIA_IMAGES (Android 13+).
    try {
      final s = await Permission.photos.status;
      return !s.isRestricted; // restricted only appears on iOS, not Android
    } catch (_) {
      return false;
    }
  }

  // ── Photo upload ─────────────────────────────────────────────────────────
  Future<void> _pickAndUploadImage() async {
    // 1. Request permission first
    final hasPermission = await _requestPhotoPermission();
    if (!hasPermission) return;

    // 2. Permission granted — open gallery
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 85,
    );
    if (picked == null) return;

    // 3. Upload
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
    final isLightSensorEnabled = ref.watch(lightSensorEnabledProvider);

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
          // ── Header ──────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.purple.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  // ── Logout button ──
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Tooltip(
                      message: 'Log Out',
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _confirmLogout,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.35),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.logout_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── Avatar + name ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
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
                              GestureDetector(
                                onTap: state.isUpdating
                                    ? null
                                    : _pickAndUploadImage, // permission check is inside
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
                  ),
                ],
              ),
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
                _settingsCard(isDark, isLightSensorEnabled),

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

  Widget _settingsCard(bool isDark, bool isLightSensorEnabled) {
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
          // ── Dark Mode ──
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

          // ── Auto Theme (Light Sensor) ──
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.wb_sunny_rounded,
                color: isLightSensorEnabled
                    ? Colors.amber[700]
                    : Colors.grey[400],
                size: 20,
              ),
            ),
            title: const Text(
              'Auto Theme',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              isLightSensorEnabled
                  ? 'On — dark in low light, light in bright'
                  : 'Off — uses manual dark mode setting',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            trailing: Switch.adaptive(
              value: isLightSensorEnabled,
              activeColor: Colors.amber[700],
              onChanged: (_) =>
                  ref.read(lightSensorEnabledProvider.notifier).toggle(),
            ),
          ),
          _divider(),

          // ── Fingerprint Login ──
          if (_isBiometricAvailable) ...[
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _isBiometricLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.green,
                        ),
                      )
                    : Icon(
                        Icons.fingerprint_rounded,
                        color: _isBiometricEnabled
                            ? Colors.green[600]
                            : Colors.grey[400],
                        size: 20,
                      ),
              ),
              title: const Text(
                'Fingerprint Login',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                _isBiometricEnabled
                    ? 'Enabled — tap to disable'
                    : 'Disabled — tap to set up',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
              trailing: Switch.adaptive(
                value: _isBiometricEnabled,
                activeColor: Colors.green[600],
                onChanged: _isBiometricLoading ? null : _toggleBiometric,
              ),
            ),
            _divider(),
          ],

          // ── Notifications ──
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

          // ── Privacy & Security ──
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
          ],
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
