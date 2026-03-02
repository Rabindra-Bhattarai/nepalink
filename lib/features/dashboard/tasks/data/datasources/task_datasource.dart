import 'package:nepalink/features/dashboard/tasks/data/models/task_api_model.dart';
import 'package:nepalink/features/dashboard/tasks/data/models/task_hive_model.dart';

/// Local data source contract
abstract interface class ITaskLocalDataSource {
  Future<TaskHiveModel> saveTask(TaskHiveModel task);
  Future<List<TaskHiveModel>> getTasksForNurse(String nurseId);
  Future<List<TaskHiveModel>> getTasksForMember(String memberId);
  Future<TaskHiveModel?> getTaskById(String id);
  Future<bool> deleteTask(String id);
}

/// Remote data source contract
abstract interface class ITaskRemoteDataSource {
  Future<TaskApiModel> createTask(TaskApiModel task);
  Future<List<TaskApiModel>> getTasksForNurse(String nurseId);
  Future<List<TaskApiModel>> getTasksForMember(String memberId);
  Future<TaskApiModel> updateTaskStatus(
    String taskId,
    String status,
    Map<String, dynamic>? updates,
  );
}
