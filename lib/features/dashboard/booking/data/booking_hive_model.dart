import 'package:hive/hive.dart';

part 'booking_hive_model.g.dart';

@HiveType(typeId: 1) // ensure unique typeId
class BookingHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String memberName;

  @HiveField(2)
  String nurseId;

  @HiveField(3)
  String status;

  @HiveField(4)
  DateTime date;

  BookingHiveModel({
    required this.id,
    required this.memberName,
    required this.nurseId,
    required this.status,
    required this.date,
  });
}
