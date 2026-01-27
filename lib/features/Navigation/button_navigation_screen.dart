import 'package:flutter/material.dart';
// import 'package:nepalink/screens/button_screen/about_screen.dart';
// import 'package:nepalink/screens/button_screen/card_screen.dart';
import 'package:nepalink/features/button_screen/home_screen.dart';
import 'package:nepalink/features/dashboard/presentation/pages/profile_screen.dart';

class ButtonNavigationScreen extends StatefulWidget {
  const ButtonNavigationScreen({super.key});

  @override
  State<ButtonNavigationScreen> createState() => _ButtonNavigationScreenState();
}

class _ButtonNavigationScreenState extends State<ButtonNavigationScreen> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [
    const HomeScreen(),
    // const CardScreen(),
    const ProfileScreen(),
    // const AboutScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.shopping_bag),
          //   label: 'Shopping',
          //),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Person'),
          // BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
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
