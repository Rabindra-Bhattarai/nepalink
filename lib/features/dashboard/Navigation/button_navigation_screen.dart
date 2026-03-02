// import 'package:flutter/material.dart';
// import 'package:nepalink/features/home/home_screen.dart';
// import 'package:nepalink/features/tasks/task_page.dart';
// import 'package:nepalink/features/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:nepalink/features/dashboard/booking/presentation/pages/booking_page.dart'; // ✅ real nurse booking UI
import 'package:nepalink/features/dashboard/presentation/pages/profile_screen.dart'; // ✅ Profile feature

class ButtonNavigationScreen extends StatefulWidget {
  const ButtonNavigationScreen({super.key});

  @override
  State<ButtonNavigationScreen> createState() => _ButtonNavigationScreenState();
}

class _ButtonNavigationScreenState extends State<ButtonNavigationScreen> {
  int _selectedIndex = 0;

  // Screens for each tab
  final List<Widget> lstBottomScreen = [
    // const HomeScreen(),
    const BookingPage(), //  nurse booking UI with ViewModel/state
    // const TaskPage(),
    // const ChatPage(),
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
        backgroundColor: Colors.blue, //  consistent dashboard theme
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
