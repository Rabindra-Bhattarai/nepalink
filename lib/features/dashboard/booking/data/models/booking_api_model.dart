import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';

class BookingApiModel {
  final String id;
  final String memberName;
  final String memberPhone;
  final String profilePic;
  final DateTime bookingDate;
  final String status;

  BookingApiModel({
    required this.id,
    required this.memberName,
    required this.memberPhone,
    required this.profilePic,
    required this.bookingDate,
    required this.status,
  });

  /// Convert API JSON to model
  factory BookingApiModel.fromJson(Map<String, dynamic> json) {
    return BookingApiModel(
      id: json['_id'] as String,
      memberName: json['memberId']?['name'] ?? '',
      memberPhone: json['memberId']?['phone'] ?? '',
      profilePic: json['memberId']?['imageUrl'] ?? '',
      bookingDate: DateTime.parse(json['date']),
      status: json['status'] ?? 'pending',
    );
  }

  /// Convert API model to domain entity
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

  /// Create API model from domain entity (for sending data back if needed)
  factory BookingApiModel.fromEntity(BookingEntity entity) {
    return BookingApiModel(
      id: entity.id,
      memberName: entity.memberName,
      memberPhone: entity.memberPhone,
      profilePic: entity.profilePic,
      bookingDate: entity.bookingDate,
      status: entity.status,
    );
  }
}
