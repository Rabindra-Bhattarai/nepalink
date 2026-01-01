class HiveTableConstant {
  // Private constructor
  HiveTableConstant._();

  // Database name
  static const String dbName = "nepalink_db";

  // Tables -> Box : TypeId
  static const int userTypeId = 0;
  static const String userTable = "user_table";

  static const int sessionTypeId = 1;
  static const String sessionTable = "session_table";
}
