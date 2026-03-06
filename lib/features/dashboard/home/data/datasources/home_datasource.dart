import 'package:nepalink/features/dashboard/home/domain/entities/activity_entity.dart';

abstract class IHomeRemoteDataSource {
  Future<List<ActivityEntity>> getAssignedActivities();
}

abstract class IHomeLocalDataSource {
  Future<List<ActivityEntity>> getAssignedActivities();
  Future<void> saveActivities(List<ActivityEntity> activities);
  Future<void> clearActivities();
}
