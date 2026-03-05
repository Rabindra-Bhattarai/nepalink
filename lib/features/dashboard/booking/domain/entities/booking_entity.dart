import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final String id; // bookingId
  final String memberId;
  final String nurseId;
  final String contractId; // ✅ always a string ObjectId
  final String memberName;
  final String memberPhone;
  final String profilePic;
  final DateTime bookingDate;
  final String status;

  const BookingEntity({
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

  factory BookingEntity.fromJson(Map<String, dynamic> json) {
    final member = (json['memberId'] is Map) ? json['memberId'] : {};
    final nurse = (json['nurseId'] is Map) ? json['nurseId'] : {};
    final contract = (json['contractId'] is Map) ? json['contractId'] : null;

    return BookingEntity(
      id: json['_id']?.toString() ?? '',
      memberId: member['_id']?.toString() ?? '',
      nurseId: nurse['_id']?.toString() ?? '',
      // ✅ Extract _id if contractId is an object, else fallback to string
      contractId:
          contract?['_id']?.toString() ?? json['contractId']?.toString() ?? '',
      memberName: member['name']?.toString() ?? '',
      memberPhone: member['phone']?.toString() ?? '',
      profilePic: member['profilePic']?.toString() ?? '',
      bookingDate:
          DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? 'pending',
    );
  }

  // ✅ copyWith for immutability-safe updates
  BookingEntity copyWith({
    String? id,
    String? memberId,
    String? nurseId,
    String? contractId,
    String? memberName,
    String? memberPhone,
    String? profilePic,
    DateTime? bookingDate,
    String? status,
  }) {
    return BookingEntity(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      nurseId: nurseId ?? this.nurseId,
      contractId: contractId ?? this.contractId,
      memberName: memberName ?? this.memberName,
      memberPhone: memberPhone ?? this.memberPhone,
      profilePic: profilePic ?? this.profilePic,
      bookingDate: bookingDate ?? this.bookingDate,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    memberId,
    nurseId,
    contractId,
    memberName,
    memberPhone,
    profilePic,
    bookingDate,
    status,
  ];
}
