import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/constants/hive_table_constants.dart';
import 'package:nepalink/features/auth/data/models/user_hive_model.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';
import 'package:nepalink/features/dashboard/tasks/domain/usecases/get_tasks_for_nurse_usecase.dart';
import 'package:nepalink/features/dashboard/tasks/domain/usecases/create_task_usecase.dart';
import 'package:nepalink/features/dashboard/tasks/domain/usecases/update_task_status_usecase.dart';
import 'package:nepalink/features/dashboard/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:nepalink/features/dashboard/tasks/presentation/view_model/task_view_model.dart';

@GenerateMocks([
  GetTasksForNurseUsecase,
  CreateTaskUsecase,
  UpdateTaskStatusUsecase,
  DeleteTaskUsecase,
])
import 'task_view_model_test.mocks.dart';

void main() {
  late TaskViewModel taskViewModel;
  late MockGetTasksForNurseUsecase mockGetTasksForNurse;
  late MockCreateTaskUsecase mockCreateTask;
  late MockUpdateTaskStatusUsecase mockUpdateTaskStatus;
  late MockDeleteTaskUsecase mockDeleteTask;

  final tTask = TaskEntity(
    id: 'task-001',
    memberId: 'member-001',
    nurseId: 'nurse-001',
    description: 'Administer medication',
    date: DateTime(2025, 3, 10),
    status: 'pending',
  );

  final tTask2 = TaskEntity(
    id: 'task-002',
    memberId: 'member-002',
    nurseId: 'nurse-001',
    description: 'Check vitals',
    date: DateTime(2025, 3, 11),
    status: 'pending',
  );

  setUpAll(() async {
    final tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
    await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
  });

  tearDownAll(() async {
    await Hive.close();
  });

  setUp(() {
    mockGetTasksForNurse = MockGetTasksForNurseUsecase();
    mockCreateTask = MockCreateTaskUsecase();
    mockUpdateTaskStatus = MockUpdateTaskStatusUsecase();
    mockDeleteTask = MockDeleteTaskUsecase();

    when(
      mockGetTasksForNurse.call(any),
    ).thenAnswer((_) async => const Right([]));

    taskViewModel = TaskViewModel(
      getTasksForNurse: mockGetTasksForNurse,
      createTask: mockCreateTask,
      updateTaskStatus: mockUpdateTaskStatus,
      deleteTask: mockDeleteTask,
    );
  });

  tearDown(() {
    taskViewModel.dispose();
  });

  group('TaskViewModel', () {
    test('loads tasks for nurse and updates state on success', () async {
      when(
        mockGetTasksForNurse.call(any),
      ).thenAnswer((_) async => Right([tTask, tTask2]));

      await taskViewModel.loadTasksForNurse('nurse-001');

      expect(taskViewModel.state.tasks.length, 2);
      expect(taskViewModel.state.isLoading, false);
      expect(taskViewModel.state.errorMessage, isNull);
    });

    test('adds new task to state on createTask success', () async {
      when(mockCreateTask.call(any)).thenAnswer((_) async => Right(tTask));

      await taskViewModel.addTask(tTask);

      expect(taskViewModel.state.tasks, contains(tTask));
      expect(taskViewModel.state.isLoading, false);
    });

    test('removes task from state on deleteTask success', () async {
      when(
        mockGetTasksForNurse.call(any),
      ).thenAnswer((_) async => Right([tTask, tTask2]));
      await taskViewModel.loadTasksForNurse('nurse-001');

      when(mockDeleteTask.call(any)).thenAnswer((_) async => const Right(true));

      await taskViewModel.deleteTask('task-001');

      expect(taskViewModel.state.tasks.any((t) => t.id == 'task-001'), false);
      expect(taskViewModel.state.tasks.length, 1);
    });

    test('sets errorMessage when loadTasksForNurse fails', () async {
      when(mockGetTasksForNurse.call(any)).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Server error')),
      );

      await taskViewModel.loadTasksForNurse('nurse-001');

      expect(taskViewModel.state.errorMessage, 'Server error');
      expect(taskViewModel.state.isLoading, false);
    });
  });
}
