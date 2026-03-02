import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/features/dashboard/tasks/presentation/view_model/task_view_model.dart';
import 'package:nepalink/features/dashboard/tasks/presentation/widgets/task_card.dart';
import 'package:nepalink/features/dashboard/tasks/presentation/pages/task_detail_page.dart';
import 'package:nepalink/features/dashboard/tasks/presentation/pages/task_create_dialog.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({super.key});

  @override
  ConsumerState<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  @override
  void initState() {
    super.initState();
    // Trigger initial fetch
    Future.microtask(() {
      ref.read(taskViewModelProvider.notifier).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskViewModelProvider);
    final taskViewModel = ref.read(taskViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: taskState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : taskState.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 80,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    taskState.errorMessage!,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              color: Colors.blue[600],
              backgroundColor: Colors.white,
              strokeWidth: 3,
              onRefresh: () async {
                await taskViewModel.loadTasks();
              },
              child: taskState.tasks.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(32),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange[100]!,
                                      Colors.orange[50]!,
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.assignment_outlined,
                                  size: 80,
                                  color: Colors.orange[600],
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                "No Tasks Yet",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Create your first task to get started",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 32),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final newTask = await showDialog(
                                    context: context,
                                    builder: (_) => const TaskCreateDialog(),
                                  );
                                  if (newTask != null) {
                                    taskViewModel.addTask(newTask);
                                  }
                                },
                                icon: const Icon(Icons.add_rounded, size: 24),
                                label: const Text(
                                  'Create Task',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange[600],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: taskState.tasks.length,
                      itemBuilder: (context, index) {
                        final task = taskState.tasks[index];
                        return TaskCard(
                          task: task,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskDetailPage(task: task),
                              ),
                            );
                          },
                          trailing: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.edit_rounded,
                                color: Colors.blue[600],
                                size: 22,
                              ),
                              onPressed: () async {
                                final updatedTask = await showDialog(
                                  context: context,
                                  builder: (_) => TaskCreateDialog(task: task),
                                );
                                if (updatedTask != null) {
                                  taskViewModel
                                      .updateTask(task.id, task.status, {
                                        "description": updatedTask.description,
                                        "vitalSigns": updatedTask.vitalSigns,
                                        "dailyCare": updatedTask.dailyCare,
                                        "medicalTracking":
                                            updatedTask.medicalTracking,
                                        "collaboration":
                                            updatedTask.collaboration,
                                        "safetyVerification":
                                            updatedTask.safetyVerification,
                                      });
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newTask = await showDialog(
            context: context,
            builder: (_) => const TaskCreateDialog(),
          );
          if (newTask != null) {
            taskViewModel.addTask(newTask);
          }
        },
        backgroundColor: Colors.orange[600],
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text(
          'New Task',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        elevation: 6,
      ),
    );
  }
}
