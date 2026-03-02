import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:nepalink/core/constants/hive_table_constants.dart';
import 'package:nepalink/features/dashboard/tasks/data/datasources/task_datasource.dart';
import 'package:nepalink/features/dashboard/tasks/data/models/task_hive_model.dart';

final taskLocalDataSourceProvider = Provider<ITaskLocalDataSource>((ref) {
  return TaskLocalDataSource();
});

class TaskLocalDataSource implements ITaskLocalDataSource {
  Box<TaskHiveModel> get _taskBox =>
      Hive.box<TaskHiveModel>(HiveTableConstant.taskTable);

  @override
  Future<TaskHiveModel> saveTask(TaskHiveModel task) async {
    await _taskBox.put(task.id, task);
    return task;
  }

  @override
  Future<List<TaskHiveModel>> getTasksForNurse(String nurseId) async {
    return _taskBox.values.where((task) => task.nurseId == nurseId).toList();
  }

  @override
  Future<List<TaskHiveModel>> getTasksForMember(String memberId) async {
    return _taskBox.values.where((task) => task.memberId == memberId).toList();
  }

  @override
  Future<TaskHiveModel?> getTaskById(String id) async {
    return _taskBox.get(id);
  }

  @override
  Future<bool> deleteTask(String id) async {
    await _taskBox.delete(id);
    return true;
  }
}
