class BookingEntity {
  final String id;
  final String memberName;
  final String memberEmail;
  final String nurseId;
  final DateTime date;
  final String status;

  BookingEntity({
    required this.id,
    required this.memberName,
    required this.memberEmail,
    required this.nurseId,
    required this.date,
    required this.status,
  });
}
