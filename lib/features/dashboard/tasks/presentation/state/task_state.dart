import 'package:equatable/equatable.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';

class TaskState extends Equatable {
  final List<TaskEntity> tasks;
  final bool isLoading;
  final String? errorMessage;

  const TaskState({
    this.tasks = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  TaskState copyWith({
    List<TaskEntity>? tasks,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [tasks, isLoading, errorMessage];
}
