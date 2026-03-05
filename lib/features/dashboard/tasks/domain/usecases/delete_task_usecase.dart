import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/usecases/app_usecases.dart';
import 'package:nepalink/features/dashboard/tasks/domain/repositories/task_repository.dart';
import 'package:nepalink/features/dashboard/tasks/data/repositories/task_repository_impl.dart';

final deleteTaskUsecaseProvider = Provider<DeleteTaskUsecase>((ref) {
  final repo = ref.read(taskRepositoryProvider);
  return DeleteTaskUsecase(taskRepository: repo);
});

class DeleteTaskUsecase implements UsecaseWithParms<bool, String> {
  final ITaskRepository _repo;

  DeleteTaskUsecase({required ITaskRepository taskRepository})
    : _repo = taskRepository;

  @override
  Future<Either<Failure, bool>> call(String taskId) {
    return _repo.deleteTask(taskId);
  }
}
