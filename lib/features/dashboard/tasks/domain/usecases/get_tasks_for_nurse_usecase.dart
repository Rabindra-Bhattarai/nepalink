import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/usecases/app_usecases.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';
import 'package:nepalink/features/dashboard/tasks/domain/repositories/task_repository.dart';
import 'package:nepalink/features/dashboard/tasks/data/repositories/task_repository_impl.dart';

final getTasksForNurseUsecaseProvider = Provider<GetTasksForNurseUsecase>((
  ref,
) {
  final repo = ref.read(taskRepositoryProvider);
  return GetTasksForNurseUsecase(taskRepository: repo);
});

class GetTasksForNurseUsecase
    implements UsecaseWithParms<List<TaskEntity>, String> {
  final ITaskRepository _repo;

  GetTasksForNurseUsecase({required ITaskRepository taskRepository})
    : _repo = taskRepository;

  @override
  Future<Either<Failure, List<TaskEntity>>> call(String nurseId) {
    return _repo.getTasksForNurse(nurseId);
  }
}
