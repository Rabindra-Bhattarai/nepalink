import 'package:flutter/material.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TaskManagerWidget());
  }
}

class TaskManagerWidget extends StatelessWidget {
  const TaskManagerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Task Manager"));
  }
}
