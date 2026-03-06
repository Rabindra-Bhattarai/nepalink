import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';
import 'package:nepalink/features/dashboard/tasks/presentation/view_model/task_view_model.dart';
import 'package:nepalink/features/dashboard/tasks/presentation/pages/task_create_dialog.dart';
import 'package:intl/intl.dart';

class TaskDetailPage extends ConsumerWidget {
  final TaskEntity task;

  const TaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(taskViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF2C3E50),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Task Details',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[400]!, Colors.blue[600]!],
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
            child: IconButton(
              icon: const Icon(Icons.edit_rounded, color: Colors.white),
              onPressed: () async {
                final updatedTask = await showDialog(
                  context: context,
                  builder: (_) => TaskCreateDialog(task: task),
                );
                if (updatedTask != null) {
                  viewModel.updateTask(task.id, task.status, {
                    "description": updatedTask.description,
                    "vitalSigns": updatedTask.vitalSigns,
                    "dailyCare": updatedTask.dailyCare,
                    "medicalTracking": updatedTask.medicalTracking,
                    "collaboration": updatedTask.collaboration,
                    "safetyVerification": updatedTask.safetyVerification,
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[400]!, Colors.orange[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.assignment_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                task.status.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.orange[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DateFormat(
                                'EEEE, MMM dd, yyyy',
                              ).format(task.date.toLocal()),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    task.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // NEW: Member and Nurse info
                  Text(
                    "Member: ${task.memberName ?? task.memberId}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "Nurse: ${task.nurseName ?? task.nurseId}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Vital Signs Section
            if (task.vitalSigns != null && task.vitalSigns!.isNotEmpty)
              _buildSection(
                context,
                'Vital Signs',
                Icons.monitor_heart_rounded,
                Colors.red,
                [
                  if (task.vitalSigns!['bloodPressure']?.isNotEmpty ?? false)
                    _buildInfoRow(
                      Icons.favorite_rounded,
                      'Blood Pressure',
                      task.vitalSigns!['bloodPressure']!,
                      Colors.red,
                    ),
                  if (task.vitalSigns!['heartRate']?.isNotEmpty ?? false)
                    _buildInfoRow(
                      Icons.monitor_heart_rounded,
                      'Heart Rate',
                      '${task.vitalSigns!['heartRate']} bpm',
                      Colors.pink,
                    ),
                  if (task.vitalSigns!['temperature']?.isNotEmpty ?? false)
                    _buildInfoRow(
                      Icons.thermostat_rounded,
                      'Temperature',
                      '${task.vitalSigns!['temperature']}°C',
                      Colors.orange,
                    ),
                  if (task.vitalSigns!['spo2']?.isNotEmpty ?? false)
                    _buildInfoRow(
                      Icons.water_drop_rounded,
                      'SpO₂',
                      '${task.vitalSigns!['spo2']}%',
                      Colors.blue,
                    ),
                ],
              ),

            // Daily Care Section
            if (task.dailyCare != null && task.dailyCare!.isNotEmpty)
              _buildSection(
                context,
                'Daily Care',
                Icons.medical_services_rounded,
                Colors.green,
                [
                  if (task.dailyCare!['meals']?.isNotEmpty ?? false)
                    _buildInfoRow(
                      Icons.restaurant_rounded,
                      'Meals',
                      task.dailyCare!['meals']!,
                      Colors.green,
                    ),
                  if (task.dailyCare!['hydration']?.isNotEmpty ?? false)
                    _buildInfoRow(
                      Icons.local_drink_rounded,
                      'Hydration',
                      task.dailyCare!['hydration']!,
                      Colors.blue,
                    ),
                  if (task.dailyCare!['hygiene']?.isNotEmpty ?? false)
                    _buildInfoRow(
                      Icons.clean_hands_rounded,
                      'Hygiene',
                      task.dailyCare!['hygiene']!,
                      Colors.purple,
                    ),
                ],
              ),

            // Medical Tracking Section
            if (task.medicalTracking != null &&
                task.medicalTracking!['notes']?.isNotEmpty == true)
              _buildSection(
                context,
                'Medical Tracking',
                Icons.healing_rounded,
                Colors.purple,
                [
                  _buildNoteCard(
                    task.medicalTracking!['notes']!,
                    Colors.purple,
                  ),
                ],
              ),

            // Collaboration Section
            if (task.collaboration != null &&
                task.collaboration!['notes']?.isNotEmpty == true)
              _buildSection(
                context,
                'Collaboration',
                Icons.people_rounded,
                Colors.teal,
                [_buildNoteCard(task.collaboration!['notes']!, Colors.teal)],
              ),

            // Safety Verification Section
            if (task.safetyVerification != null &&
                task.safetyVerification!['notes']?.isNotEmpty == true)
              _buildSection(
                context,
                'Safety Verification',
                Icons.verified_user_rounded,
                Colors.indigo,
                [
                  _buildNoteCard(
                    task.safetyVerification!['notes']!,
                    Colors.indigo,
                  ),
                ],
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(String note, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        note,
        style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
      ),
    );
  }
}
