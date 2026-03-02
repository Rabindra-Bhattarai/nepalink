import 'package:hive/hive.dart';
import 'package:nepalink/features/dashboard/booking/data/models/booking_hive_model.dart';
import 'package:nepalink/features/dashboard/tasks/data/models/task_hive_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nepalink/core/constants/hive_table_constants.dart';
import 'package:nepalink/features/auth/data/models/user_hive_model.dart';

class HiveService {
  /// Initialize Hive with a custom path and open all required boxes
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);

    // Register all adapters (User, Booking, Task, etc.)
    _registerAdapter();

    // Open the Hive boxes so they’re ready for use
    await _openBoxes();
  }

  /// Register Hive adapters for each model
  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.bookingTypeId)) {
      Hive.registerAdapter(BookingHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.taskTypeId)) {
      Hive.registerAdapter(TaskHiveModelAdapter());
    }
  }

  /// Open all the Hive boxes we need
  Future<void> _openBoxes() async {
    await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
    await Hive.openBox<BookingHiveModel>(HiveTableConstant.bookingTable);
    await Hive.openBox<TaskHiveModel>(HiveTableConstant.taskTable);
  }

  /// Close Hive completely (useful for app shutdown or cleanup)
  Future<void> close() async {
    await Hive.close();
  }

  // ======================= Auth Queries =========================

  Box<UserHiveModel> get _userBox =>
      Hive.box<UserHiveModel>(HiveTableConstant.userTable);

  /// Save a new user into Hive
  Future<UserHiveModel> register(UserHiveModel user) async {
    await _userBox.put(user.userid, user);
    return user;
  }

  /// Try to log in by matching email + password
  Future<UserHiveModel?> login(String email, String password) async {
    try {
      return _userBox.values.firstWhere(
        (user) =>
            user.email.trim().toLowerCase() == email.trim().toLowerCase() &&
            user.password == password.trim(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Get a user by their ID
  UserHiveModel? getUserById(String userid) => _userBox.get(userid);

  /// Find a user by email
  UserHiveModel? getUserByEmail(String email) {
    try {
      return _userBox.values.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  /// Return the first user in the box (acts like "current user")
  UserHiveModel? getCurrentUser() {
    if (_userBox.isEmpty) return null;
    return _userBox.values.first;
  }

  /// Update an existing user
  Future<bool> updateUser(UserHiveModel user) async {
    if (_userBox.containsKey(user.userid)) {
      await _userBox.put(user.userid, user);
      return true;
    }
    return false;
  }

  /// Delete a user by ID
  Future<void> deleteUser(String userid) async {
    await _userBox.delete(userid);
  }

  /// Clear session/logout (currently just returns true)
  Future<bool> logout() async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }

  // ======================= Booking Queries =========================

  /// Access the booking box directly
  Box<BookingHiveModel> getBookingBox() {
    return Hive.box<BookingHiveModel>(HiveTableConstant.bookingTable);
  }

  // ======================= Task Queries =========================

  /// Access the task box directly
  Box<TaskHiveModel> getTaskBox() {
    return Hive.box<TaskHiveModel>(HiveTableConstant.taskTable);
  }
}
