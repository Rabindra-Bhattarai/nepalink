import 'package:flutter/material.dart';
import 'package:nepalink/features/auth/presentation/widgets/task_manager_widget.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TaskManagerWidget());
  }
}
