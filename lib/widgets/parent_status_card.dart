import 'package:flutter/material.dart';

class ParentStatusCard extends StatelessWidget {
  final String parentName;
  final String status; // "OK", "Attention", "Alert"
  final String lastCheckIn;
  final String health;

  const ParentStatusCard({
    super.key,
    required this.parentName,
    required this.status,
    required this.lastCheckIn,
    required this.health,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case "ok":
        return const Color(0xFF4CAF50); // Green
      case "attention":
        return const Color(0xFFFF9800); // Orange
      case "alert":
        return const Color(0xFFF44336); // Red
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parent name
            Text(
              parentName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              ),
            ),
            const SizedBox(height: 8),

            // Status row
            Row(
              children: [
                Icon(Icons.shield, color: statusColor),
                const SizedBox(width: 6),
                Text(
                  "Status: $status",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ],
            ),

            // Last check-in
            Text("Last check-in: $lastCheckIn",
                style: const TextStyle(fontSize: 13)),

            // Health indicator
            Text("Health: $health",
                style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
