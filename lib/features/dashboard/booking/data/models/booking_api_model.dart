import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';

class BookingApiModel {
  final String id;
  final String memberId;
  final String nurseId;
  final String contractId;   // ✅ new
  final String memberName;
  final String memberPhone;
  final String profilePic;
  final DateTime bookingDate;
  final String status;

  BookingApiModel({
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

  factory BookingApiModel.fromJson(Map<String, dynamic> json) {
    return BookingApiModel(
      id: json['_id'] as String,
      memberId: json['memberId']?['_id'] ?? '',
      nurseId: json['nurseId']?['_id'] ?? '',
      contractId: json['contractId'] ?? '', // ✅ parse contractId if backend includes it
      memberName: json['memberId']?['name'] ?? '',
      memberPhone: json['memberId']?['phone'] ?? '',
      profilePic: json['memberId']?['imageUrl'] ?? '',
      bookingDate: DateTime.parse(json['date']),
      status: json['status'] ?? 'pending',
    );
  }

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

  factory BookingApiModel.fromEntity(BookingEntity entity) {
    return BookingApiModel(
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
}
