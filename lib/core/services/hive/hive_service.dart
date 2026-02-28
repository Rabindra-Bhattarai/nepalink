import 'package:hive/hive.dart';
import 'package:nepalink/features/dashboard/booking/data/booking_hive_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nepalink/core/constants/hive_table_constants.dart';
import 'package:nepalink/features/auth/data/models/user_hive_model.dart';

class HiveService {
  // init Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);

    // register adapters
    _registerAdapter();

    // open boxes
    await _openBoxes();
  }

  // register adapters
  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(BookingHiveModelAdapter());
    }
  }

  // open boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
    await Hive.openBox<BookingHiveModel>('bookings'); // ✅ consistent name
  }

  // close Hive
  Future<void> close() async {
    await Hive.close();
  }

  // ======================= Auth Queries =========================

  Box<UserHiveModel> get _userBox =>
      Hive.box<UserHiveModel>(HiveTableConstant.userTable);

  Future<UserHiveModel> register(UserHiveModel user) async {
    await _userBox.put(user.userid, user);
    return user;
  }

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

  UserHiveModel? getUserById(String userid) => _userBox.get(userid);

  UserHiveModel? getUserByEmail(String email) {
    try {
      return _userBox.values.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  UserHiveModel? getCurrentUser() {
    if (_userBox.isEmpty) return null;
    return _userBox.values.first;
  }

  Future<bool> updateUser(UserHiveModel user) async {
    if (_userBox.containsKey(user.userid)) {
      await _userBox.put(user.userid, user);
      return true;
    }
    return false;
  }

  Future<void> deleteUser(String userid) async {
    await _userBox.delete(userid);
  }

  Future<bool> logout() async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }

  // ======================= Booking Queries =========================

  /// Helper to access the booking box
  Box<BookingHiveModel> getBookingBox() {
    return Hive.box<BookingHiveModel>('bookings'); // ✅ consistent name
  }
}
