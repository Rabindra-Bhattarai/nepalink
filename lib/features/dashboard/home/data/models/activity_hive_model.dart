import 'package:hive/hive.dart';

part 'activity_hive_model.g.dart';

@HiveType(typeId: 5)
class ActivityHiveModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String memberId;
  @HiveField(2)
  String nurseId;
  @HiveField(3)
  String description;
  @HiveField(4)
  DateTime date;
  @HiveField(5)
  String status;
  @HiveField(6)
  DateTime createdAt;
  @HiveField(7)
  DateTime updatedAt;

  // VitalSigns
  @HiveField(8)
  String? bloodPressure;
  @HiveField(9)
  double? heartRate;
  @HiveField(10)
  double? temperature;
  @HiveField(11)
  double? spo2;

  // DailyCare
  @HiveField(12)
  String? meals;
  @HiveField(13)
  String? hydration;
  @HiveField(14)
  String? hygiene;
  @HiveField(15)
  String? mobility;
  @HiveField(16)
  String? sleepQuality;

  // MedicalTracking
  @HiveField(17)
  String? medication;
  @HiveField(18)
  double? painLevel;
  @HiveField(19)
  String? woundCondition;
  @HiveField(20)
  String? bowelBladder;

  // Collaboration
  @HiveField(21)
  String? suppliesInventory;
  @HiveField(22)
  String? shiftSummary;
  @HiveField(23)
  String? parentInstructions;
  @HiveField(24)
  String? significantEvents;

  // SafetyVerification
  @HiveField(25)
  String? equipmentCheck;
  @HiveField(26)
  bool? emergencyContactSync;
  @HiveField(27)
  bool? jointSignature;

  ActivityHiveModel({
    required this.id,
    required this.memberId,
    required this.nurseId,
    required this.description,
    required this.date,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.bloodPressure,
    this.heartRate,
    this.temperature,
    this.spo2,
    this.meals,
    this.hydration,
    this.hygiene,
    this.mobility,
    this.sleepQuality,
    this.medication,
    this.painLevel,
    this.woundCondition,
    this.bowelBladder,
    this.suppliesInventory,
    this.shiftSummary,
    this.parentInstructions,
    this.significantEvents,
    this.equipmentCheck,
    this.emergencyContactSync,
    this.jointSignature,
  });
}
