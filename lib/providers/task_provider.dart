import 'package:flutter_riverpod/legacy.dart';
import '../models/task.dart';

final taskProvider = StateProvider<List<Task>>((ref) {
  return [
    Task(
      title: "Medication reminder",
      dateTime: DateTime.now().add(const Duration(hours: 1)),
      caregiver: "A",
      category: "Medication",
    ),
    Task(
      title: "Exercise",
      dateTime: DateTime.now().add(const Duration(hours: 2)),
      caregiver: "B",
      category: "Exercise",
    ),
    Task(
      title: "Checkup",
      dateTime: DateTime.now().add(const Duration(days: 1)),
      caregiver: "C",
      category: "Checkup",
    ),
    Task(
      title: "Report submission",
      dateTime: DateTime.now().subtract(const Duration(hours: 3)),
      caregiver: "D",
      category: "Report",
      isCompleted: true,
    ),
    Task(
      title: "Follow-up call",
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      caregiver: "A",
      category: "Medication",
      isOverdue: true,
    ),
  ];
});
