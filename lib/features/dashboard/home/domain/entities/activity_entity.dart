import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final String id;
  final String memberId;
  final String nurseId;
  final String description;
  final DateTime date;
  final String status; // pending | completed | cancelled
  final VitalSignsEntity? vitalSigns;
  final DailyCareEntity? dailyCare;
  final MedicalTrackingEntity? medicalTracking;
  final CollaborationEntity? collaboration;
  final SafetyVerificationEntity? safetyVerification;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ActivityEntity({
    required this.id,
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
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    memberId,
    nurseId,
    description,
    date,
    status,
    vitalSigns,
    dailyCare,
    medicalTracking,
    collaboration,
    safetyVerification,
    createdAt,
    updatedAt,
  ];
}

class VitalSignsEntity extends Equatable {
  final String? bloodPressure;
  final double? heartRate;
  final double? temperature;
  final double? spo2;

  const VitalSignsEntity({
    this.bloodPressure,
    this.heartRate,
    this.temperature,
    this.spo2,
  });

  @override
  List<Object?> get props => [bloodPressure, heartRate, temperature, spo2];
}

class DailyCareEntity extends Equatable {
  final String? meals;
  final String? hydration;
  final String? hygiene;
  final String? mobility;
  final String? sleepQuality;

  const DailyCareEntity({
    this.meals,
    this.hydration,
    this.hygiene,
    this.mobility,
    this.sleepQuality,
  });

  @override
  List<Object?> get props => [
    meals,
    hydration,
    hygiene,
    mobility,
    sleepQuality,
  ];
}

class MedicalTrackingEntity extends Equatable {
  final String? medication;
  final double? painLevel;
  final String? woundCondition;
  final String? bowelBladder;

  const MedicalTrackingEntity({
    this.medication,
    this.painLevel,
    this.woundCondition,
    this.bowelBladder,
  });

  @override
  List<Object?> get props => [
    medication,
    painLevel,
    woundCondition,
    bowelBladder,
  ];
}

class CollaborationEntity extends Equatable {
  final String? suppliesInventory;
  final String? shiftSummary;
  final String? parentInstructions;
  final String? significantEvents;

  const CollaborationEntity({
    this.suppliesInventory,
    this.shiftSummary,
    this.parentInstructions,
    this.significantEvents,
  });

  @override
  List<Object?> get props => [
    suppliesInventory,
    shiftSummary,
    parentInstructions,
    significantEvents,
  ];
}

class SafetyVerificationEntity extends Equatable {
  final String? equipmentCheck;
  final bool? emergencyContactSync;
  final bool? jointSignature;

  const SafetyVerificationEntity({
    this.equipmentCheck,
    this.emergencyContactSync,
    this.jointSignature,
  });

  @override
  List<Object?> get props => [
    equipmentCheck,
    emergencyContactSync,
    jointSignature,
  ];
}
