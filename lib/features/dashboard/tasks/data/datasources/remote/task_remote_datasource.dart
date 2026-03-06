import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/api/api_client.dart';
import 'package:nepalink/core/api/api_endpoints.dart';
import 'package:nepalink/features/dashboard/tasks/data/datasources/task_datasource.dart';
import 'package:nepalink/features/dashboard/tasks/data/models/task_api_model.dart';

final taskRemoteDataSourceProvider = Provider<ITaskRemoteDataSource>((ref) {
  return TaskRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

class TaskRemoteDataSource implements ITaskRemoteDataSource {
  final ApiClient _apiClient;

  TaskRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<TaskApiModel> createTask(TaskApiModel task) async {
    final response = await _apiClient.post(
      ApiEndpoints.activityCreate,
      data: task.toJson(),
    );
    return TaskApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<TaskApiModel>> getTasksForNurse(String nurseId) async {
    final response = await _apiClient.get(ApiEndpoints.activitiesAssigned);
    final List<dynamic> data = response.data['data'];
    return data.map((json) => TaskApiModel.fromJson(json)).toList();
  }

  @override
  Future<List<TaskApiModel>> getTasksForMember(String memberId) async {
    final response = await _apiClient.get(ApiEndpoints.activitiesMy);
    final List<dynamic> data = response.data['data'];
    return data.map((json) => TaskApiModel.fromJson(json)).toList();
  }

  @override
  Future<TaskApiModel> updateTaskStatus(
    String taskId,
    String status,
    Map<String, dynamic>? updates,
  ) async {
    final response = await _apiClient.put(
      ApiEndpoints.activityUpdateStatus(taskId),
      data: {"status": status, ...?updates},
    );
    return TaskApiModel.fromJson(response.data['data']);
  }


  @override
  Future<bool> deleteTask(String taskId) async {
    await _apiClient.delete(ApiEndpoints.activityDelete(taskId));
    return true;
  }
}