import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/services/connectivity/network_info.dart';
import 'package:nepalink/features/dashboard/home/data/datasources/home_datasource.dart';
import 'package:nepalink/features/dashboard/home/data/datasources/local/home_local_datasource.dart';
import 'package:nepalink/features/dashboard/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:nepalink/features/dashboard/home/domain/entities/activity_entity.dart';
import 'package:nepalink/features/dashboard/home/domain/repositories/home_repository.dart';

final homeRepositoryProvider = Provider<IHomeRepository>((ref) {
  final remote = ref.read(homeRemoteDataSourceProvider);
  final local = ref.read(homeLocalDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return HomeRepositoryImpl(
    remote: remote,
    local: local,
    networkInfo: networkInfo,
  );
});

class HomeRepositoryImpl implements IHomeRepository {
  final IHomeRemoteDataSource _remote;
  final IHomeLocalDataSource _local;
  final NetworkInfo _networkInfo;

  HomeRepositoryImpl({
    required IHomeRemoteDataSource remote,
    required IHomeLocalDataSource local,
    required NetworkInfo networkInfo,
  }) : _remote = remote,
       _local = local,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<ActivityEntity>>> getAssignedActivities() async {
    if (await _networkInfo.isConnected) {
      try {
        final activities = await _remote.getAssignedActivities();
        await _local.saveActivities(activities); // cache locally
        return Right(activities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final activities = await _local.getAssignedActivities();
        return Right(activities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
