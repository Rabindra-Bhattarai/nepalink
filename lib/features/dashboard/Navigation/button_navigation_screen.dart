import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:shake/shake.dart';
import 'package:nepalink/core/providers/theme_provider.dart';
import 'package:nepalink/features/dashboard/ai/presentation/pages/ai_page.dart';
import 'package:nepalink/features/dashboard/chat/presentation/screens/chat_tab.dart';
import 'package:nepalink/features/dashboard/home/presentation/pages/home_page.dart';
import 'package:nepalink/features/dashboard/tasks/presentation/pages/task_page.dart';
import 'package:nepalink/features/dashboard/booking/presentation/pages/booking_page.dart';
import 'package:nepalink/features/dashboard/profile/presentation/pages/profile_screen.dart';
import 'package:nepalink/features/dashboard/notification/presentation/widgets/notification_bell.dart';
import 'package:nepalink/features/dashboard/notification/presentation/view_model/notification_view_model.dart';
import 'package:nepalink/features/auth/presentation/view_model/login_viewmodel.dart';

class ButtonNavigationScreen extends ConsumerStatefulWidget {
  const ButtonNavigationScreen({super.key});

  @override
  ConsumerState<ButtonNavigationScreen> createState() =>
      _ButtonNavigationScreenState();
}

class _ButtonNavigationScreenState
    extends ConsumerState<ButtonNavigationScreen> {
  int _selectedIndex = 0;

  // ── Proximity sensor (logout) ──
  StreamSubscription<dynamic>? _proximitySub;
  bool _isLoggingOut = false;

  // ── Shake detector (theme toggle) ──
  ShakeDetector? _shakeDetector;

  final List<Widget> lstBottomScreen = [
    const HomePage(),
    const BookingPage(),
    const TaskPage(),
    const AiPage(),
    const ChatTab(),
    const ProfileScreen(),
  ];

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home_rounded, 'label': 'Home', 'color': Colors.blue},
    {
      'icon': Icons.calendar_month_rounded,
      'label': 'Booking',
      'color': Colors.purple,
    },
    {'icon': Icons.assignment_rounded, 'label': 'Task', 'color': Colors.orange},
    {'icon': Icons.auto_awesome, 'label': 'AI', 'color': Colors.deepPurple},
    {'icon': Icons.chat_bubble_rounded, 'label': 'Chat', 'color': Colors.green},
    {'icon': Icons.person_rounded, 'label': 'Profile', 'color': Colors.teal},
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationViewModelProvider.notifier).loadNotifications();
    });
    _startProximitySensor();
    _startShakeDetector();
  }

  // ── Proximity sensor — logout ──────────────────────────────────────────────
  void _startProximitySensor() {
    try {
      _proximitySub = ProximitySensor.events.listen((int event) {
        if (event > 0 && !_isLoggingOut) {
          _triggerProximityLogout();
        }
      });
    } catch (e) {
      debugPrint('Proximity sensor not available: $e');
    }
  }

  Future<void> _triggerProximityLogout() async {
    _isLoggingOut = true;
    await _playBeeps();
    if (!mounted) return;
    _showLogoutOverlay();
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    await ref.read(loginViewModelProvider.notifier).logout();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<void> _playBeeps() async {
    for (int i = 0; i < 3; i++) {
      await SystemSound.play(SystemSoundType.click);
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  void _showLogoutOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sensor_door_rounded,
                  color: Colors.red[400],
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Logging Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Proximity sensor detected.\nSigning you out safely...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              const LinearProgressIndicator(
                backgroundColor: Color(0xFFEEEEEE),
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Shake detector — toggle theme ─────────────────────────────────────────
  void _startShakeDetector() {
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () async {
        // Toggle theme
        await ref.read(themeModeProvider.notifier).toggle();

        // Haptic + show toast
        await HapticFeedback.heavyImpact();
        if (!mounted) return;

        final isDark = ref.read(themeModeProvider) == ThemeMode.dark;
        _showThemeToast(isDark);
      },
      minimumShakeCount: 2, // shakes needed to trigger
      shakeSlopTimeMS: 500, // ms between shake counts
      shakeCountResetTime: 3000, // reset count after 3s
      shakeThresholdGravity: 2.7, // sensitivity (lower = easier to trigger)
    );
  }

  void _showThemeToast(bool isDark) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              isDark ? 'Dark mode on 🌙' : 'Light mode on ☀️',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
        backgroundColor: isDark
            ? const Color(0xFF2C3E50)
            : const Color(0xFF2A9D7A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _proximitySub?.cancel();
    _shakeDetector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.purple.shade400],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_hospital_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Nepalink',
              style: TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [const NotificationBell(), const SizedBox(width: 8)],
      ),
      body: lstBottomScreen[_selectedIndex],
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          child: BottomAppBar(
            elevation: 0,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _navItems.length,
                (index) => _buildNavItem(
                  icon: _navItems[index]['icon'],
                  label: _navItems[index]['label'],
                  color: _navItems[index]['color'],
                  index: index,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required Color color,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 12 : 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isSelected)
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                Icon(
                  icon,
                  color: isSelected ? color : Colors.grey[400],
                  size: isSelected ? 26 : 22,
                ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                child: Text(label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
