import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/features/dashboard/tasks/presentation/view_model/task_view_model.dart';
import 'package:nepalink/features/dashboard/tasks/presentation/widgets/task_card.dart';
import 'package:nepalink/features/dashboard/tasks/presentation/pages/task_detail_page.dart';
import 'package:nepalink/features/dashboard/tasks/presentation/pages/task_create_dialog.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';

class TaskPage extends ConsumerStatefulWidget {
  const TaskPage({super.key});

  @override
  ConsumerState<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends ConsumerState<TaskPage> {
  // ✅ Save messenger once in state — never look it up after async gaps
  late ScaffoldMessengerState _messenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _messenger = ScaffoldMessenger.of(context);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(taskViewModelProvider.notifier).loadTasks();
    });
  }

  Future<void> _openCreateDialog() async {
    final newTask = await showDialog(
      context: context,
      builder: (_) => const TaskCreateDialog(),
    );
    if (newTask != null) {
      ref.read(taskViewModelProvider.notifier).addTask(newTask);
    }
  }

  void _showSnackBar(bool success) {
    _messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle_rounded : Icons.error_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(success ? 'Task deleted' : 'Failed to delete task'),
          ],
        ),
        backgroundColor: success ? Colors.green[600] : Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<bool> _showDeleteDialog(TaskEntity task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.delete_rounded,
                color: Colors.red[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Delete Task',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to delete this task?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                task.description,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
              style: TextStyle(fontSize: 12, color: Colors.red[400]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: const Icon(Icons.delete_rounded, size: 18),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  Future<void> _handleDelete(TaskEntity task) async {
    final confirmed = await _showDeleteDialog(task);
    if (!confirmed) return;
    final success = await ref
        .read(taskViewModelProvider.notifier)
        .deleteTask(task.id);
    _showSnackBar(success);
  }

  Widget _buildCreateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _openCreateDialog,
          icon: const Icon(Icons.add_rounded, size: 24),
          label: const Text(
            '+ New Task',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskViewModelProvider);
    final taskViewModel = ref.read(taskViewModelProvider.notifier);

    if (taskState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (taskState.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
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
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => taskViewModel.loadTasks(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (taskState.tasks.isEmpty) {
      return RefreshIndicator(
        color: Colors.orange[600],
        onRefresh: () async => taskViewModel.loadTasks(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 60),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange[100]!, Colors.orange[50]!],
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
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildCreateButton(),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: Colors.orange[600],
      onRefresh: () async => taskViewModel.loadTasks(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        itemCount: taskState.tasks.length + 1,
        itemBuilder: (context, index) {
          if (index == taskState.tasks.length) return _buildCreateButton();

          final task = taskState.tasks[index];

          return Dismissible(
            key: ValueKey(task.id),
            direction: DismissDirection.endToStart,
            // ✅ confirmDismiss only returns bool — no snackbar here
            confirmDismiss: (_) async {
              final confirmed = await _showDeleteDialog(task);
              if (!confirmed) return false;
              final success = await ref
                  .read(taskViewModelProvider.notifier)
                  .deleteTask(task.id);
              // ✅ Use the stored _messenger — safe even after widget deactivates
              _showSnackBar(success);
              return success;
            },
            background: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red[600],
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_rounded, color: Colors.white, size: 28),
                  SizedBox(height: 4),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            child: TaskCard(
              task: task,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaskDetailPage(task: task)),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
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
                          taskViewModel.updateTask(task.id, task.status, {
                            "description": updatedTask.description,
                            "vitalSigns": updatedTask.vitalSigns,
                            "dailyCare": updatedTask.dailyCare,
                            "medicalTracking": updatedTask.medicalTracking,
                            "collaboration": updatedTask.collaboration,
                            "safetyVerification":
                                updatedTask.safetyVerification,
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.delete_rounded,
                        color: Colors.red[600],
                        size: 22,
                      ),
                      // ✅ Uses _handleDelete which safely uses _messenger
                      onPressed: () => _handleDelete(task),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
