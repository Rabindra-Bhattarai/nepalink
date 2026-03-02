import 'package:dartz/dartz.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';

abstract interface class ITaskRepository {
  /// Fetch all tasks assigned to a nurse
  Future<Either<Failure, List<TaskEntity>>> getTasksForNurse(String nurseId);

  /// Fetch all tasks assigned to a member
  Future<Either<Failure, List<TaskEntity>>> getTasksForMember(String memberId);

  /// Create a new task/activity
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task);

  /// Update task status or details
  Future<Either<Failure, TaskEntity>> updateTaskStatus(
    String taskId,
    String status,
    Map<String, dynamic>? updates,
  );
}
