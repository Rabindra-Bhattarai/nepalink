import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String memberId;
  final String nurseId;
  final String description;
  final DateTime date;
  final String status;

  // Optional extra info from nested objects
  final String? memberName;
  final String? memberEmail;
  final String? nurseName;
  final String? nurseEmail;

  // Structured fields normalized to Map<String, String>
  final Map<String, String>? vitalSigns;
  final Map<String, String>? dailyCare;
  final Map<String, String>? medicalTracking;
  final Map<String, String>? collaboration;
  final Map<String, String>? safetyVerification;

  const TaskEntity({
    required this.id,
    required this.memberId,
    required this.nurseId,
    required this.description,
    required this.date,
    required this.status,
    this.memberName,
    this.memberEmail,
    this.nurseName,
    this.nurseEmail,
    this.vitalSigns,
    this.dailyCare,
    this.medicalTracking,
    this.collaboration,
    this.safetyVerification,
  });

  @override
  List<Object?> get props => [
    id,
    memberId,
    nurseId,
    description,
    date,
    status,
    memberName,
    memberEmail,
    nurseName,
    nurseEmail,
    vitalSigns,
    dailyCare,
    medicalTracking,
    collaboration,
    safetyVerification,
  ];

  /// Factory to create from JSON (backend response)
  factory TaskEntity.fromJson(Map<String, dynamic> json) {
    final memberObj = json["memberId"];
    final nurseObj = json["nurseId"];

    Map<String, String>? _normalize(Map<String, dynamic>? raw) {
      if (raw == null) return null;
      return raw.map((k, v) => MapEntry(k.toString(), v?.toString() ?? ""));
    }

    return TaskEntity(
      id: json["_id"] ?? "",
      memberId: memberObj is Map ? memberObj["_id"] ?? "" : memberObj ?? "",
      nurseId: nurseObj is Map ? nurseObj["_id"] ?? "" : nurseObj ?? "",
      memberName: memberObj is Map ? memberObj["name"] as String? : null,
      memberEmail: memberObj is Map ? memberObj["email"] as String? : null,
      nurseName: nurseObj is Map ? nurseObj["name"] as String? : null,
      nurseEmail: nurseObj is Map ? nurseObj["email"] as String? : null,
      description: json["description"] ?? "",
      date: DateTime.tryParse(json["date"] ?? "") ?? DateTime.now(),
      status: json["status"] ?? "pending",
      vitalSigns: _normalize(json["vitalSigns"] as Map<String, dynamic>?),
      dailyCare: _normalize(json["dailyCare"] as Map<String, dynamic>?),
      medicalTracking: _normalize(
        json["medicalTracking"] as Map<String, dynamic>?,
      ),
      collaboration: _normalize(json["collaboration"] as Map<String, dynamic>?),
      safetyVerification: _normalize(
        json["safetyVerification"] as Map<String, dynamic>?,
      ),
    );
  }

  /// Convert to JSON (for sending to backend)
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "memberId": memberId,
      "nurseId": nurseId,
      "description": description,
      "date": date.toIso8601String(),
      "status": status,
      "vitalSigns": vitalSigns,
      "dailyCare": dailyCare,
      "medicalTracking": medicalTracking,
      "collaboration": collaboration,
      "safetyVerification": safetyVerification,
    };
  }
}
