import 'package:dartz/dartz.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/home/domain/entities/activity_entity.dart';

abstract class IHomeRepository {
  /// Nurse: fetch activities assigned to them
  Future<Either<Failure, List<ActivityEntity>>> getAssignedActivities();
}
