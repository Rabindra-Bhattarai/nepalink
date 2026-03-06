import 'package:flutter/material.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onTap;
  final Widget? trailing;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.trailing,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return Colors.green[600]!;
      case "in-progress":
        return Colors.blue[600]!;
      case "pending":
        return Colors.orange[600]!;
      case "cancelled":
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return Icons.check_circle_rounded;
      case "in-progress":
        return Icons.hourglass_empty_rounded;
      case "pending":
        return Icons.pending_actions_rounded;
      case "cancelled":
        return Icons.cancel_rounded;
      default:
        return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, _statusColor(task.status).withOpacity(0.02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _statusColor(task.status).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _statusColor(task.status).withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Status Icon with gradient background
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _statusColor(task.status).withOpacity(0.2),
                            _statusColor(task.status).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _statusColor(task.status).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _statusIcon(task.status),
                        color: _statusColor(task.status),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Task Description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.description,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(task.status),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              task.status.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Trailing widget (edit button)
                    if (trailing != null) trailing!,
                  ],
                ),

                const SizedBox(height: 12),

                // Date and Time Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: _statusColor(task.status),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat(
                          'EEE, MMM dd, yyyy',
                        ).format(task.date.toLocal()),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: _statusColor(task.status),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('hh:mm a').format(task.date.toLocal()),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),

                // Vital Signs Preview (if available)
                if (task.vitalSigns != null && task.vitalSigns!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (task.vitalSigns!['bloodPressure']?.isNotEmpty ??
                          false)
                        _buildVitalChip(
                          Icons.favorite_rounded,
                          'BP: ${task.vitalSigns!['bloodPressure']}',
                          Colors.red,
                        ),
                      if (task.vitalSigns!['heartRate']?.isNotEmpty ?? false)
                        _buildVitalChip(
                          Icons.monitor_heart_rounded,
                          'HR: ${task.vitalSigns!['heartRate']}',
                          Colors.pink,
                        ),
                      if (task.vitalSigns!['temperature']?.isNotEmpty ?? false)
                        _buildVitalChip(
                          Icons.thermostat_rounded,
                          '${task.vitalSigns!['temperature']}°C',
                          Colors.orange,
                        ),
                      if (task.vitalSigns!['spo2']?.isNotEmpty ?? false)
                        _buildVitalChip(
                          Icons.water_drop_rounded,
                          'SpO₂: ${task.vitalSigns!['spo2']}%',
                          Colors.blue,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVitalChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
