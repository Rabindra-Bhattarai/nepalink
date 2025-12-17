import 'package:flutter/material.dart';
import 'package:nepalink/widgets/parent_status_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            ParentStatusCard(
              parentName: "Mr. Bhattarai",
              status: "OK",
              lastCheckIn: "10:45 AM",
              health: "Good",
            ),
          ],
        ),
      ),
    );
  }
}
