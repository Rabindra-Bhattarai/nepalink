import 'package:flutter/material.dart';
//import 'package:nepalink/features/button_screen/home_screen.dart';
import 'package:nepalink/features/button_screen/booking_page.dart';
import 'package:nepalink/features/button_screen/task_page.dart';
import 'package:nepalink/features/button_screen/chat_page.dart';
import 'package:nepalink/features/dashboard/presentation/pages/profile_screen.dart';

class ButtonNavigationScreen extends StatefulWidget {
  const ButtonNavigationScreen({super.key});

  @override
  State<ButtonNavigationScreen> createState() => _ButtonNavigationScreenState();
}

class _ButtonNavigationScreenState extends State<ButtonNavigationScreen> {
  int _selectedIndex = 0;

  // Screens for each tab
  final List<Widget> lstBottomScreen = [
    //const HomeScreen(),
    const BookingPage(),
    const TaskPage(),
    const ChatPage(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Booking',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Task'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        backgroundColor: Colors.amber,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.blue,
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
