import 'package:flutter/material.dart';
import 'package:nepalink/features/button_screen/home_screen.dart';
import 'package:nepalink/features/button_screen/task_page.dart';
import 'package:nepalink/features/button_screen/chat_page.dart';
import 'package:nepalink/features/button_screen/booking_page.dart';
import 'package:nepalink/features/dashboard/presentation/pages/profile_screen.dart';
import 'package:nepalink/features/dashboard/notification/presentation/widgets/notification_bell.dart'; // ✅ added

class CaregiverDashboard extends StatefulWidget {
  const CaregiverDashboard({super.key});

  @override
  State<CaregiverDashboard> createState() => _CaregiverDashboardState();
}

class _CaregiverDashboardState extends State<CaregiverDashboard> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [
    const HomeScreen(),
    const TaskPage(),
    const BookingPage(),
    const ChatPage(),
    const ProfileScreen(),
  ];

  void _refreshPage() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: _refreshPage,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Image.asset(
                  'assets/images/nepalink.png',
                  height: 80,
                  width: 160,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
          // ✅ Replaced plain IconButton with NotificationBell
          // Shows red badge with unread count automatically
          const NotificationBell(),
        ],
      ),
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
