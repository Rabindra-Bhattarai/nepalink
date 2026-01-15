import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile avatar
          const CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),
          const SizedBox(height: 16),

          // Name (dummy)
          const Text(
            "User Name",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Dummy features
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings (dummy)"),
          ),
          const ListTile(
            leading: Icon(Icons.history),
            title: Text("Order History (dummy)"),
          ),
          const ListTile(
            leading: Icon(Icons.favorite),
            title: Text("Favorites (dummy)"),
          ),

          const Divider(),

          // Logout button
          ElevatedButton.icon(
            onPressed: () {
              // Frontend only: show feedback
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logout clicked")),
              );

              // Later: connect to backend logout logic
              // e.g. authBloc.add(LogoutEvent());
              // or Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
