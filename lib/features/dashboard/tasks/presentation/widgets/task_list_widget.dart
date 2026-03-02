import 'package:flutter/material.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';

/// A widget that displays a list of tasks
class TaskListWidget extends StatelessWidget {
  final List<TaskEntity> tasks;

  const TaskListWidget({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text("No activities found"));
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            title: Text(
              task.description,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Date: ${task.date.toLocal()}"),
                Text("Status: ${task.status}"),
                Text("Member: ${task.memberName ?? task.memberId}"),
                Text("Nurse: ${task.nurseName ?? task.nurseId}"),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}
