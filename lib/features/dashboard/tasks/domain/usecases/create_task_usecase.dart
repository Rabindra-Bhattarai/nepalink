import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/usecases/app_usecases.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';
import 'package:nepalink/features/dashboard/tasks/domain/repositories/task_repository.dart';
import 'package:nepalink/features/dashboard/tasks/data/repositories/task_repository_impl.dart';

final createTaskUsecaseProvider = Provider<CreateTaskUsecase>((ref) {
  final repo = ref.read(taskRepositoryProvider);
  return CreateTaskUsecase(taskRepository: repo);
});

class CreateTaskUsecase implements UsecaseWithParms<TaskEntity, TaskEntity> {
  final ITaskRepository _repo;

  CreateTaskUsecase({required ITaskRepository taskRepository})
    : _repo = taskRepository;

  @override
  Future<Either<Failure, TaskEntity>> call(TaskEntity task) {
    return _repo.createTask(task);
  }
}
