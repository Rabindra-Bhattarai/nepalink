import 'package:dartz/dartz.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';

abstract interface class ITaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasksForNurse(String nurseId);
  Future<Either<Failure, List<TaskEntity>>> getTasksForMember(String memberId);
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task);
  Future<Either<Failure, TaskEntity>> updateTaskStatus(
    String taskId,
    String status,
    Map<String, dynamic>? updates,
  );

  Future<Either<Failure, bool>> deleteTask(String taskId);
}
