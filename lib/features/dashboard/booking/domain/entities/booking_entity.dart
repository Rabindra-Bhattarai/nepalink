import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final String id;
  final String memberName;
  final String memberPhone;
  final String profilePic;
  final DateTime bookingDate;
  final String status;

  const BookingEntity({
    required this.id,
    required this.memberName,
    required this.memberPhone,
    required this.profilePic,
    required this.bookingDate,
    required this.status,
  });

  /// For API mapping
  factory BookingEntity.fromJson(Map<String, dynamic> json) {
    final member = json['memberId'] ?? {};
    return BookingEntity(
      id: json['_id']?.toString() ?? '',
      memberName: member['name']?.toString() ?? '',
      memberPhone: member['phone']?.toString() ?? '',
      profilePic: member['imageUrl']?.toString() ?? '', // safe null handling
      bookingDate:
          DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? 'pending',
    );
  }

  @override
  List<Object?> get props => [
    id,
    memberName,
    memberPhone,
    profilePic,
    bookingDate,
    status,
  ];
}
