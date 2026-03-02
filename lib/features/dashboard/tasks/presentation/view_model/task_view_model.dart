import 'package:flutter_riverpod/legacy.dart';
import 'package:nepalink/core/services/hive/hive_service.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';
import 'package:nepalink/features/dashboard/tasks/domain/usecases/get_tasks_for_nurse_usecase.dart';
import 'package:nepalink/features/dashboard/tasks/domain/usecases/create_task_usecase.dart';
import 'package:nepalink/features/dashboard/tasks/domain/usecases/update_task_status_usecase.dart';
// import 'package:nepalink/features/dashboard/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:nepalink/features/dashboard/tasks/presentation/state/task_state.dart';

final taskViewModelProvider = StateNotifierProvider<TaskViewModel, TaskState>((
  ref,
) {
  final getTasksForNurse = ref.read(getTasksForNurseUsecaseProvider);
  final createTask = ref.read(createTaskUsecaseProvider);
  final updateTaskStatus = ref.read(updateTaskStatusUsecaseProvider);

  return TaskViewModel(
    getTasksForNurse: getTasksForNurse,
    createTask: createTask,
    updateTaskStatus: updateTaskStatus,
  );
});

class TaskViewModel extends StateNotifier<TaskState> {
  final GetTasksForNurseUsecase _getTasksForNurse;
  final CreateTaskUsecase _createTask;
  final UpdateTaskStatusUsecase _updateTaskStatus;

  TaskViewModel({
    required GetTasksForNurseUsecase getTasksForNurse,
    required CreateTaskUsecase createTask,
    required UpdateTaskStatusUsecase updateTaskStatus,
  }) : _getTasksForNurse = getTasksForNurse,
       _createTask = createTask,
       _updateTaskStatus = updateTaskStatus,
       super(const TaskState()) {
    _loadInitialTasks();
  }

  /// Load tasks once when ViewModel is created
  Future<void> _loadInitialTasks() async {
    await loadTasks();
  }

  /// Public method for UI refresh (decides based on current user role)
  Future<void> loadTasks() async {
    final hiveService = HiveService();
    final currentUser = hiveService.getCurrentUser();

    if (currentUser != null) {
      if (currentUser.role == "nurse") {
        await loadTasksForNurse(currentUser.userid);
      }
      // If you also want member tasks later:
      // else if (currentUser.role == "member") {
      //   await loadTasksForMember(currentUser.userid);
      // }
    }
  }

  Future<void> loadTasksForNurse(String nurseId) async {
    state = state.copyWith(isLoading: true);
    final result = await _getTasksForNurse.call(nurseId);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (tasks) => state = state.copyWith(isLoading: false, tasks: tasks),
    );
  }

  Future<void> addTask(TaskEntity task) async {
    state = state.copyWith(isLoading: true);
    final result = await _createTask.call(task);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (newTask) => state = state.copyWith(
        isLoading: false,
        tasks: [...state.tasks, newTask],
      ),
    );
  }

  Future<void> updateTask(
    String taskId,
    String status,
    Map<String, dynamic>? updates,
  ) async {
    state = state.copyWith(isLoading: true);
    final result = await _updateTaskStatus.call(
      UpdateTaskStatusParams(taskId: taskId, status: status, updates: updates),
    );
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (updatedTask) {
        final updatedList = state.tasks
            .map((t) => t.id == taskId ? updatedTask : t)
            .toList();
        state = state.copyWith(isLoading: false, tasks: updatedList);
      },
    );
  }
}
