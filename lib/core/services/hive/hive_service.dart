// lib/core/services/hive/hive_service.dart

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nepalink/core/constants/hive_table_constants.dart';
import 'package:nepalink/features/auth/data/models/user_hive_model.dart';
import 'package:nepalink/features/dashboard/booking/data/models/booking_hive_model.dart';
import 'package:nepalink/features/dashboard/tasks/data/models/task_hive_model.dart';
import 'package:nepalink/features/dashboard/chat/data/models/chat_hive_model.dart';
import 'package:nepalink/features/dashboard/home/data/models/activity_hive_model.dart';
import 'package:nepalink/features/dashboard/profile/data/models/profile_hive_model.dart'; // ✅

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);

    _registerAdapter();
    await _openBoxes();
  }

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
    if (!Hive.isAdapterRegistered(HiveTableConstant.chatTypeId)) {
      Hive.registerAdapter(ChatHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.activityTypeId)) {
      Hive.registerAdapter(ActivityHiveModelAdapter());
    }
    // ✅ Profile
    if (!Hive.isAdapterRegistered(HiveTableConstant.profileTypeId)) {
      Hive.registerAdapter(ProfileHiveModelAdapter());
    }
  }

  Future<void> _openBoxes() async {
    await Hive.openBox<UserHiveModel>(HiveTableConstant.userTable);
    await Hive.openBox<BookingHiveModel>(HiveTableConstant.bookingTable);
    await Hive.openBox<TaskHiveModel>(HiveTableConstant.taskTable);
    await Hive.openBox<ChatHiveModel>(HiveTableConstant.chatTable);
    await Hive.openBox<ActivityHiveModel>(HiveTableConstant.activityTable);
    await Hive.openBox<ProfileHiveModel>(HiveTableConstant.profileTable); // ✅
  }

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

  Box<BookingHiveModel> getBookingBox() {
    return Hive.box<BookingHiveModel>(HiveTableConstant.bookingTable);
  }

  // ======================= Task Queries =========================

  Box<TaskHiveModel> getTaskBox() {
    return Hive.box<TaskHiveModel>(HiveTableConstant.taskTable);
  }

  // ======================= Chat Queries =========================

  Box<ChatHiveModel> getChatBox() {
    return Hive.box<ChatHiveModel>(HiveTableConstant.chatTable);
  }

  Future<void> saveChatMessage(ChatHiveModel message) async {
    await getChatBox().put(message.id, message);
  }

  List<ChatHiveModel> getMessagesByContract(String contractId) {
    return getChatBox().values
        .where((msg) => msg.contractId == contractId)
        .toList();
  }

  Future<void> markMessagesRead(String contractId) async {
    final box = getChatBox();
    final messages = box.values.where(
      (msg) => msg.contractId == contractId && !msg.isRead,
    );
    for (var msg in messages) {
      final updated = ChatHiveModel(
        id: msg.id,
        contractId: msg.contractId,
        senderId: msg.senderId,
        receiverId: msg.receiverId,
        message: msg.message,
        isRead: true,
        attachments: msg.attachments,
        createdAt: msg.createdAt,
      );
      await box.put(updated.id, updated);
    }
  }

  // ======================= Activity Queries =========================

  Box<ActivityHiveModel> getActivityBox() {
    return Hive.box<ActivityHiveModel>(HiveTableConstant.activityTable);
  }

  Future<void> saveActivities(List<ActivityHiveModel> activities) async {
    final box = getActivityBox();
    await box.clear();
    for (final activity in activities) {
      await box.put(activity.id, activity);
    }
  }

  List<ActivityHiveModel> getActivities() {
    return getActivityBox().values.toList();
  }

  Future<void> clearActivities() async {
    await getActivityBox().clear();
  }

  // ======================= Profile Queries =========================

  Box<ProfileHiveModel> getProfileBox() {
    return Hive.box<ProfileHiveModel>(HiveTableConstant.profileTable);
  }

  Future<void> saveProfile(ProfileHiveModel profile) async {
    await getProfileBox().put(profile.id, profile);
  }

  ProfileHiveModel? getProfile() {
    final box = getProfileBox();
    return box.values.isNotEmpty ? box.values.first : null;
  }

  Future<void> clearProfile() async {
    await getProfileBox().clear();
  }
}
