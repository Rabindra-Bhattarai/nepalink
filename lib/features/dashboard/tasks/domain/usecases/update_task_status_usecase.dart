import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/usecases/app_usecases.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';
import 'package:nepalink/features/dashboard/tasks/domain/repositories/task_repository.dart';
import 'package:nepalink/features/dashboard/tasks/data/repositories/task_repository_impl.dart';

class UpdateTaskStatusParams {
  final String taskId;
  final String status;
  final Map<String, dynamic>? updates;

  UpdateTaskStatusParams({
    required this.taskId,
    required this.status,
    this.updates,
  });
}

final updateTaskStatusUsecaseProvider = Provider<UpdateTaskStatusUsecase>((
  ref,
) {
  final repo = ref.read(taskRepositoryProvider);
  return UpdateTaskStatusUsecase(taskRepository: repo);
});

class UpdateTaskStatusUsecase
    implements UsecaseWithParms<TaskEntity, UpdateTaskStatusParams> {
  final ITaskRepository _repo;

  UpdateTaskStatusUsecase({required ITaskRepository taskRepository})
    : _repo = taskRepository;

  @override
  Future<Either<Failure, TaskEntity>> call(UpdateTaskStatusParams params) {
    return _repo.updateTaskStatus(params.taskId, params.status, params.updates);
  }
}
