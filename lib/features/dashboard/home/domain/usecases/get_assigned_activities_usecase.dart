import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/home/data/repositories/home_repository_impl.dart';
import 'package:nepalink/features/dashboard/home/domain/entities/activity_entity.dart';
import 'package:nepalink/features/dashboard/home/domain/repositories/home_repository.dart';

final getAssignedActivitiesUsecaseProvider =
    Provider<GetAssignedActivitiesUsecase>((ref) {
      final repo = ref.read(homeRepositoryProvider);
      return GetAssignedActivitiesUsecase(repo);
    });

class GetAssignedActivitiesUsecase {
  final IHomeRepository _repo;
  GetAssignedActivitiesUsecase(this._repo);

  Future<Either<Failure, List<ActivityEntity>>> call() {
    return _repo.getAssignedActivities();
  }
}
