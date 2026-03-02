import 'package:hive/hive.dart';
import 'package:nepalink/core/constants/hive_table_constants.dart';
import 'package:nepalink/features/dashboard/tasks/domain/entities/task_entity.dart';
import 'package:uuid/uuid.dart';

part 'task_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.taskTypeId)
class TaskHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String memberId;

  @HiveField(2)
  final String nurseId;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String status;

  // Structured fields normalized to Map<String, String>
  @HiveField(6)
  final Map<String, String>? vitalSigns;

  @HiveField(7)
  final Map<String, String>? dailyCare;

  @HiveField(8)
  final Map<String, String>? medicalTracking;

  @HiveField(9)
  final Map<String, String>? collaboration;

  @HiveField(10)
  final Map<String, String>? safetyVerification;

  TaskHiveModel({
    String? id,
    required this.memberId,
    required this.nurseId,
    required this.description,
    required this.date,
    required this.status,
    this.vitalSigns,
    this.dailyCare,
    this.medicalTracking,
    this.collaboration,
    this.safetyVerification,
  }) : id = id ?? const Uuid().v4();

  /// Convert Hive model to domain entity
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
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

  /// Create Hive model from domain entity
  factory TaskHiveModel.fromEntity(TaskEntity entity) {
    return TaskHiveModel(
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

  /// Convert list of Hive models to list of domain entities
  static List<TaskEntity> toEntityList(List<TaskHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
