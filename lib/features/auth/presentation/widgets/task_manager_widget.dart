import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/data/models/task.dart';
import '../../../../core/providers/task_provider.dart';

class TaskManagerWidget extends ConsumerWidget {
  const TaskManagerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue),
            tooltip: "Add Task",
            onPressed: () {
              _showAddTaskDialog(context, ref);
            },
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(child: Text("No tasks yet. Add one!"))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: task.isOverdue
                            ? Colors.red
                            : task.isCompleted
                            ? Colors.green
                            : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      "${task.category} • ${task.caregiver}\n${task.dateTime}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            final updatedTasks = [...tasks];
                            updatedTasks[index] = Task(
                              title: task.title,
                              dateTime: task.dateTime,
                              caregiver: task.caregiver,
                              category: task.category,
                              isCompleted: true,
                              isOverdue: false,
                            );
                            ref.read(taskProvider.notifier).state =
                                updatedTasks;
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            final updatedTasks = [...tasks]..removeAt(index);
                            ref.read(taskProvider.notifier).state =
                                updatedTasks;
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      _showEditTaskDialog(context, ref, task, index);
                    },
                  ),
                );
              },
            ),
    );
  }

  /// Add Task Dialog
  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final caregiverController = TextEditingController();
    DateTime? selectedDate;
    String category = "Medication";
    bool isCompleted = false;
    bool isOverdue = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Task"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: category,
                      decoration: const InputDecoration(labelText: "Category"),
                      items: const [
                        DropdownMenuItem(
                          value: "Medication",
                          child: Text("Medication"),
                        ),
                        DropdownMenuItem(
                          value: "Exercise",
                          child: Text("Exercise"),
                        ),
                        DropdownMenuItem(
                          value: "Checkup",
                          child: Text("Checkup"),
                        ),
                        DropdownMenuItem(
                          value: "Report",
                          child: Text("Report"),
                        ),
                      ],
                      onChanged: (value) => setState(() => category = value!),
                    ),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Title"),
                    ),
                    TextField(
                      controller: caregiverController,
                      decoration: const InputDecoration(labelText: "Caregiver"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              selectedDate = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        }
                      },
                      child: const Text("Pick Date & Time"),
                    ),
                    CheckboxListTile(
                      title: const Text("Completed"),
                      value: isCompleted,
                      onChanged: (val) =>
                          setState(() => isCompleted = val ?? false),
                    ),
                    CheckboxListTile(
                      title: const Text("Overdue"),
                      value: isOverdue,
                      onChanged: (val) =>
                          setState(() => isOverdue = val ?? false),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        selectedDate != null) {
                      final newTask = Task(
                        title: titleController.text,
                        dateTime: selectedDate!,
                        caregiver: caregiverController.text,
                        category: category,
                        isCompleted: isCompleted,
                        isOverdue: isOverdue,
                      );
                      ref.read(taskProvider.notifier).state = [
                        ...ref.read(taskProvider),
                        newTask,
                      ];
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Edit Task Dialog
  void _showEditTaskDialog(
    BuildContext context,
    WidgetRef ref,
    Task task,
    int index,
  ) {
    final titleController = TextEditingController(text: task.title);
    final caregiverController = TextEditingController(text: task.caregiver);
    DateTime selectedDate = task.dateTime;
    String category = task.category;
    bool isCompleted = task.isCompleted;
    bool isOverdue = task.isOverdue;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Edit Task"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: category,
                      decoration: const InputDecoration(labelText: "Category"),
                      items: const [
                        DropdownMenuItem(
                          value: "Medication",
                          child: Text("Medication"),
                        ),
                        DropdownMenuItem(
                          value: "Exercise",
                          child: Text("Exercise"),
                        ),
                        DropdownMenuItem(
                          value: "Checkup",
                          child: Text("Checkup"),
                        ),
                        DropdownMenuItem(
                          value: "Report",
                          child: Text("Report"),
                        ),
                      ],
                      onChanged: (value) => setState(() => category = value!),
                    ),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Title"),
                    ),
                    TextField(
                      controller: caregiverController,
                      decoration: const InputDecoration(labelText: "Caregiver"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );

                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(selectedDate),
                          );
                          if (time != null) {
                            setState(() {
                              selectedDate = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        }
                      },
                      child: const Text("Pick Date & Time"),
                    ),
                    CheckboxListTile(
                      title: const Text("Completed"),
                      value: isCompleted,
                      onChanged: (val) =>
                          setState(() => isCompleted = val ?? false),
                    ),
                    CheckboxListTile(
                      title: const Text("Overdue"),
                      value: isOverdue,
                      onChanged: (val) =>
                          setState(() => isOverdue = val ?? false),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final updatedTask = Task(
                      title: titleController.text,
                      dateTime: selectedDate,
                      caregiver: caregiverController.text,
                      category: category,
                      isCompleted: isCompleted,
                      isOverdue: isOverdue,
                    );
                    final updatedTasks = [...ref.read(taskProvider)];
                    updatedTasks[index] = updatedTask;
                    ref.read(taskProvider.notifier).state = updatedTasks;
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
