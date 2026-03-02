import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/usecases/app_usecases.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';
import 'package:nepalink/features/dashboard/tasks/domain/repositories/task_repository.dart';
import 'package:nepalink/features/dashboard/tasks/data/repositories/task_repository_impl.dart';

final getTasksForMemberUsecaseProvider = Provider<GetTasksForMemberUsecase>((
  ref,
) {
  final repo = ref.read(taskRepositoryProvider);
  return GetTasksForMemberUsecase(taskRepository: repo);
});

class GetTasksForMemberUsecase
    implements UsecaseWithParms<List<TaskEntity>, String> {
  final ITaskRepository _repo;

  GetTasksForMemberUsecase({required ITaskRepository taskRepository})
    : _repo = taskRepository;

  @override
  Future<Either<Failure, List<TaskEntity>>> call(String memberId) {
    return _repo.getTasksForMember(memberId);
  }
}
