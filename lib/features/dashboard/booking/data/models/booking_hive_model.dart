import 'package:hive/hive.dart';
import 'package:nepalink/core/constants/hive_table_constants.dart';
import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';

part 'booking_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.bookingTypeId)
class BookingHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String memberName;

  @HiveField(2)
  final String memberPhone;

  @HiveField(3)
  final String profilePic;

  @HiveField(4)
  final DateTime bookingDate;

  @HiveField(5)
  final String status;

  BookingHiveModel({
    required this.id,
    required this.memberName,
    required this.memberPhone,
    required this.profilePic,
    required this.bookingDate,
    required this.status,
  });

  /// Convert Hive model to domain entity
  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      memberName: memberName,
      memberPhone: memberPhone,
      profilePic: profilePic,
      bookingDate: bookingDate,
      status: status,
    );
  }

  /// Create Hive model from domain entity
  factory BookingHiveModel.fromEntity(BookingEntity entity) {
    return BookingHiveModel(
      id: entity.id,
      memberName: entity.memberName,
      memberPhone: entity.memberPhone,
      profilePic: entity.profilePic,
      bookingDate: entity.bookingDate,
      status: entity.status,
    );
  }

  /// Update booking status locally
  BookingHiveModel copyWith({String? status}) {
    return BookingHiveModel(
      id: id,
      memberName: memberName,
      memberPhone: memberPhone,
      profilePic: profilePic,
      bookingDate: bookingDate,
      status: status ?? this.status,
    );
  }
}
