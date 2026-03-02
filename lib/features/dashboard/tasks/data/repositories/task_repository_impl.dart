import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/tasks/data/datasources/local/task_local_datasource.dart';
import 'package:nepalink/features/dashboard/tasks/data/datasources/remote/task_remote_datasource.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';
import 'package:nepalink/features/dashboard/tasks/domain/repositories/task_repository.dart';
import 'package:nepalink/features/dashboard/tasks/data/datasources/task_datasource.dart';
import 'package:nepalink/features/dashboard/tasks/data/models/task_api_model.dart';
import 'package:nepalink/features/dashboard/tasks/data/models/task_hive_model.dart';
import 'package:nepalink/core/services/connectivity/network_info.dart';

final taskRepositoryProvider = Provider<ITaskRepository>((ref) {
  final local = ref.read(taskLocalDataSourceProvider);
  final remote = ref.read(taskRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return TaskRepositoryImpl(
    localDataSource: local,
    remoteDataSource: remote,
    networkInfo: networkInfo,
  );
});

class TaskRepositoryImpl implements ITaskRepository {
  final ITaskLocalDataSource _local;
  final ITaskRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  TaskRepositoryImpl({
    required ITaskLocalDataSource localDataSource,
    required ITaskRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _local = localDataSource,
       _remote = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksForNurse(
    String nurseId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final tasks = await _remote.getTasksForNurse(nurseId);
        return Right(tasks.map((t) => t.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final tasks = await _local.getTasksForNurse(nurseId);
        return Right(TaskHiveModel.toEntityList(tasks));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksForMember(
    String memberId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final tasks = await _remote.getTasksForMember(memberId);
        return Right(tasks.map((t) => t.toEntity()).toList());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final tasks = await _local.getTasksForMember(memberId);
        return Right(TaskHiveModel.toEntityList(tasks));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = TaskApiModel.fromEntity(task);
        final created = await _remote.createTask(apiModel);
        return Right(created.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final hiveModel = TaskHiveModel.fromEntity(task);
        final saved = await _local.saveTask(hiveModel);
        return Right(saved.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTaskStatus(
    String taskId,
    String status,
    Map<String, dynamic>? updates,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final updated = await _remote.updateTaskStatus(taskId, status, updates);
        return Right(updated.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final task = await _local.getTaskById(taskId);
        if (task == null) {
          return Left(LocalDatabaseFailure(message: "Task not found offline"));
        }
        final updatedHiveTask = TaskHiveModel(
          id: task.id,
          memberId: task.memberId,
          nurseId: task.nurseId,
          description: task.description,
          date: task.date,
          status: status,
          vitalSigns: updates?['vitalSigns'] ?? task.vitalSigns,
          dailyCare: updates?['dailyCare'] ?? task.dailyCare,
          medicalTracking: updates?['medicalTracking'] ?? task.medicalTracking,
          collaboration: updates?['collaboration'] ?? task.collaboration,
          safetyVerification:
              updates?['safetyVerification'] ?? task.safetyVerification,
        );
        await _local.saveTask(updatedHiveTask);
        return Right(updatedHiveTask.toEntity());
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
