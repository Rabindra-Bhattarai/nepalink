import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/features/dashboard/chat/presentation/screens/chat_tab.dart';
import 'package:nepalink/features/dashboard/home/presentation/pages/home_page.dart';
import 'package:nepalink/features/dashboard/tasks/presentation/pages/task_page.dart';
import 'package:nepalink/features/dashboard/booking/presentation/pages/booking_page.dart';
import 'package:nepalink/features/dashboard/presentation/pages/profile_screen.dart';
import 'package:nepalink/features/dashboard/notification/presentation/widgets/notification_bell.dart';
import 'package:nepalink/features/dashboard/notification/presentation/view_model/notification_view_model.dart';

// ✅ Changed from StatefulWidget to ConsumerStatefulWidget
class ButtonNavigationScreen extends ConsumerStatefulWidget {
  const ButtonNavigationScreen({super.key});

  @override
  ConsumerState<ButtonNavigationScreen> createState() =>
      _ButtonNavigationScreenState();
}

// ✅ Changed from State to ConsumerState
class _ButtonNavigationScreenState
    extends ConsumerState<ButtonNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> lstBottomScreen = [
    const HomePage(),
    const BookingPage(),
    const TaskPage(),
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
    {'icon': Icons.chat_bubble_rounded, 'label': 'Chat', 'color': Colors.green},
    {'icon': Icons.person_rounded, 'label': 'Profile', 'color': Colors.teal},
  ];

  @override
  void initState() {
    super.initState();
    // ✅ Load notifications after first frame so token is ready
    Future.microtask(() {
      ref.read(notificationViewModelProvider.notifier).loadNotifications();
    });
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
          horizontal: isSelected ? 16 : 12,
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                Icon(
                  icon,
                  color: isSelected ? color : Colors.grey[400],
                  size: isSelected ? 28 : 24,
                ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
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
