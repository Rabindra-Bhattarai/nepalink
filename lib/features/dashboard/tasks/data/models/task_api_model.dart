import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';

class TaskApiModel {
  final String? id;
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

  TaskApiModel({
    this.id,
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

  /// Convert API JSON to model
  factory TaskApiModel.fromJson(Map<String, dynamic> json) {
    Map<String, String>? _normalize(Map<String, dynamic>? raw) {
      if (raw == null) return null;
      return raw.map((key, value) => MapEntry(key, value?.toString() ?? ''));
    }

    final memberObj = json['memberId'];
    final nurseObj = json['nurseId'];

    return TaskApiModel(
      id: json['_id'] as String?,
      memberId: memberObj is Map
          ? memberObj['_id'] as String
          : memberObj as String,
      nurseId: nurseObj is Map ? nurseObj['_id'] as String : nurseObj as String,
      memberName: memberObj is Map ? memberObj['name'] as String? : null,
      memberEmail: memberObj is Map ? memberObj['email'] as String? : null,
      nurseName: nurseObj is Map ? nurseObj['name'] as String? : null,
      nurseEmail: nurseObj is Map ? nurseObj['email'] as String? : null,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      vitalSigns: _normalize(json['vitalSigns'] as Map<String, dynamic>?),
      dailyCare: _normalize(json['dailyCare'] as Map<String, dynamic>?),
      medicalTracking: _normalize(
        json['medicalTracking'] as Map<String, dynamic>?,
      ),
      collaboration: _normalize(json['collaboration'] as Map<String, dynamic>?),
      safetyVerification: _normalize(
        json['safetyVerification'] as Map<String, dynamic>?,
      ),
    );
  }

  /// Convert model to JSON (for POST/PUT requests)
  Map<String, dynamic> toJson() {
    return {
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

  /// Convert API model to domain entity
  TaskEntity toEntity() {
    return TaskEntity(
      id: id ?? '',
      memberId: memberId,
      nurseId: nurseId,
      description: description,
      date: date,
      status: status,
      vitalSigns: vitalSigns,
      dailyCare: dailyCare,
      medicalTracking: medicalTracking,
      collaboration: collaboration,
      safetyVerification: safetyVerification,
    );
  }

  /// Create API model from domain entity
  factory TaskApiModel.fromEntity(TaskEntity entity) {
    return TaskApiModel(
      id: entity.id,
      memberId: entity.memberId,
      nurseId: entity.nurseId,
      description: entity.description,
      date: entity.date,
      status: entity.status,
      vitalSigns: entity.vitalSigns,
      dailyCare: entity.dailyCare,
      medicalTracking: entity.medicalTracking,
      collaboration: entity.collaboration,
      safetyVerification: entity.safetyVerification,
    );
  }
}
