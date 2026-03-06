import 'package:hive/hive.dart';
import 'package:nepalink/core/constants/hive_table_constants.dart';
import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';

part 'booking_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.bookingTypeId)
class BookingHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String memberId;

  @HiveField(2)
  final String nurseId;

  @HiveField(3)
  final String contractId; // ✅ new

  @HiveField(4)
  final String memberName;

  @HiveField(5)
  final String memberPhone;

  @HiveField(6)
  final String profilePic;

  @HiveField(7)
  final DateTime bookingDate;

  @HiveField(8)
  final String status;

  BookingHiveModel({
    required this.id,
    required this.memberId,
    required this.nurseId,
    required this.contractId,
    required this.memberName,
    required this.memberPhone,
    required this.profilePic,
    required this.bookingDate,
    required this.status,
  });

  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      memberId: memberId,
      nurseId: nurseId,
      contractId: contractId,
      memberName: memberName,
      memberPhone: memberPhone,
      profilePic: profilePic,
      bookingDate: bookingDate,
      status: status,
    );
  }

  factory BookingHiveModel.fromEntity(BookingEntity entity) {
    return BookingHiveModel(
      id: entity.id,
      memberId: entity.memberId,
      nurseId: entity.nurseId,
      contractId: entity.contractId,
      memberName: entity.memberName,
      memberPhone: entity.memberPhone,
      profilePic: entity.profilePic,
      bookingDate: entity.bookingDate,
      status: entity.status,
    );
  }

  BookingHiveModel copyWith({String? status}) {
    return BookingHiveModel(
      id: id,
      memberId: memberId,
      nurseId: nurseId,
      contractId: contractId,
      memberName: memberName,
      memberPhone: memberPhone,
      profilePic: profilePic,
      bookingDate: bookingDate,
      status: status ?? this.status,
    );
  }
}
