import 'package:flutter/material.dart';
import 'package:nepalink/features/button_screen/home_screen.dart';
import 'package:nepalink/features/button_screen/task_screen.dart';
import 'package:nepalink/features/button_screen/caregiver_screen.dart';
import 'package:nepalink/features/button_screen/location_screen.dart';
import 'package:nepalink/features/button_screen/profile_screen.dart';

class CaregiverDashboard extends StatefulWidget {
  const CaregiverDashboard({super.key});

  @override
  State<CaregiverDashboard> createState() => _CaregiverDashboardState();
}

class _CaregiverDashboardState extends State<CaregiverDashboard> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [
    const HomeScreen(),
    const TaskScreen(),
    const LocationScreen(),
    const CaregiverScreen(),
    const ProfileScreen(),
  ];

  void _refreshPage() {
    setState(() {
      _selectedIndex = 0; // reset to Home tab
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
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Task'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'location'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Caregiver'),
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
