// lib/core/constants/hive_table_constants.dart

class HiveTableConstant {
  HiveTableConstant._();

  static const String dbName = "nepalink_db";

  // User
  static const int userTypeId = 0;
  static const String userTable = "user_table";

  // Session
  static const int sessionTypeId = 1;
  static const String sessionTable = "session_table";

  // Booking
  static const int bookingTypeId = 2;
  static const String bookingTable = "booking_table";

  // Task / Activity
  static const int taskTypeId = 3;
  static const String taskTable = "task_table";

  // Chat
  static const int chatTypeId = 4;
  static const String chatTable = "chat_table";

  // Home Activity
  static const int activityTypeId = 5;
  static const String activityTable = "activity_table";

  //  Profile
  static const int profileTypeId = 6;
  static const String profileTable = "profile_table";
}
