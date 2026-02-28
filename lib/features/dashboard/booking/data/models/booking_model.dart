class UserSummary {
  final String id;
  final String name;
  final String email;
  final String role;
  final String phone;

  UserSummary({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) {
    return UserSummary(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
    );
  }
}

class BookingModel {
  final String id;
  final UserSummary member;
  final String nurseId;
  final String status;
  final DateTime date;

  BookingModel({
    required this.id,
    required this.member,
    required this.nurseId,
    required this.status,
    required this.date,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'],
      member: UserSummary.fromJson(json['memberId']),
      nurseId: json['nurseId'],
      status: json['status'],
      date: DateTime.parse(json['date']),
    );
  }
}
