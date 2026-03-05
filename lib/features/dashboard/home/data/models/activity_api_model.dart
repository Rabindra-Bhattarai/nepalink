import 'package:nepalink/features/dashboard/home/domain/entities/activity_entity.dart';
import 'package:nepalink/features/dashboard/home/data/models/activity_hive_model.dart';

class ActivityApiModel {
  final String id;
  final String memberId;
  final String nurseId;
  final String description;
  final DateTime date;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // VitalSigns
  final String? bloodPressure;
  final double? heartRate;
  final double? temperature;
  final double? spo2;

  // DailyCare
  final String? meals;
  final String? hydration;
  final String? hygiene;
  final String? mobility;
  final String? sleepQuality;

  // MedicalTracking
  final String? medication;
  final double? painLevel;
  final String? woundCondition;
  final String? bowelBladder;

  // Collaboration
  final String? suppliesInventory;
  final String? shiftSummary;
  final String? parentInstructions;
  final String? significantEvents;

  // SafetyVerification
  final String? equipmentCheck;
  final bool? emergencyContactSync;
  final bool? jointSignature;

  ActivityApiModel({
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

  /// Safely extract plain ID from nested object or plain string
  static String _extractId(dynamic raw) {
    if (raw == null) return '';
    if (raw is Map)
      return raw['_id']?.toString() ?? raw['id']?.toString() ?? '';
    final str = raw.toString().trim();
    if (RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(str)) return str;
    final match = RegExp(r'_id:\s*([a-fA-F0-9]{24})').firstMatch(str);
    if (match != null) return match.group(1)!;
    return str;
  }

  factory ActivityApiModel.fromJson(Map<String, dynamic> json) {
    final v = json['vitalSigns'] as Map<String, dynamic>?;
    final d = json['dailyCare'] as Map<String, dynamic>?;
    final m = json['medicalTracking'] as Map<String, dynamic>?;
    final c = json['collaboration'] as Map<String, dynamic>?;
    final s = json['safetyVerification'] as Map<String, dynamic>?;

    return ActivityApiModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      memberId: _extractId(json['memberId']),
      nurseId: _extractId(json['nurseId']),
      description: json['description']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? 'pending',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
      // VitalSigns
      bloodPressure: v?['bloodPressure']?.toString(),
      heartRate: (v?['heartRate'] as num?)?.toDouble(),
      temperature: (v?['temperature'] as num?)?.toDouble(),
      spo2: (v?['spo2'] as num?)?.toDouble(),
      // DailyCare
      meals: d?['meals']?.toString(),
      hydration: d?['hydration']?.toString(),
      hygiene: d?['hygiene']?.toString(),
      mobility: d?['mobility']?.toString(),
      sleepQuality: d?['sleepQuality']?.toString(),
      // MedicalTracking
      medication: m?['medication']?.toString(),
      painLevel: (m?['painLevel'] as num?)?.toDouble(),
      woundCondition: m?['woundCondition']?.toString(),
      bowelBladder: m?['bowelBladder']?.toString(),
      // Collaboration
      suppliesInventory: c?['suppliesInventory']?.toString(),
      shiftSummary: c?['shiftSummary']?.toString(),
      parentInstructions: c?['parentInstructions']?.toString(),
      significantEvents: c?['significantEvents']?.toString(),
      // SafetyVerification
      equipmentCheck: s?['equipmentCheck']?.toString(),
      emergencyContactSync: s?['emergencyContactSync'] as bool?,
      jointSignature: s?['jointSignature'] as bool?,
    );
  }

  ActivityEntity toEntity() => ActivityEntity(
    id: id,
    memberId: memberId,
    nurseId: nurseId,
    description: description,
    date: date,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
    vitalSigns:
        (bloodPressure != null ||
            heartRate != null ||
            temperature != null ||
            spo2 != null)
        ? VitalSignsEntity(
            bloodPressure: bloodPressure,
            heartRate: heartRate,
            temperature: temperature,
            spo2: spo2,
          )
        : null,
    dailyCare:
        (meals != null ||
            hydration != null ||
            hygiene != null ||
            mobility != null ||
            sleepQuality != null)
        ? DailyCareEntity(
            meals: meals,
            hydration: hydration,
            hygiene: hygiene,
            mobility: mobility,
            sleepQuality: sleepQuality,
          )
        : null,
    medicalTracking:
        (medication != null ||
            painLevel != null ||
            woundCondition != null ||
            bowelBladder != null)
        ? MedicalTrackingEntity(
            medication: medication,
            painLevel: painLevel,
            woundCondition: woundCondition,
            bowelBladder: bowelBladder,
          )
        : null,
    collaboration:
        (suppliesInventory != null ||
            shiftSummary != null ||
            parentInstructions != null ||
            significantEvents != null)
        ? CollaborationEntity(
            suppliesInventory: suppliesInventory,
            shiftSummary: shiftSummary,
            parentInstructions: parentInstructions,
            significantEvents: significantEvents,
          )
        : null,
    safetyVerification:
        (equipmentCheck != null ||
            emergencyContactSync != null ||
            jointSignature != null)
        ? SafetyVerificationEntity(
            equipmentCheck: equipmentCheck,
            emergencyContactSync: emergencyContactSync,
            jointSignature: jointSignature,
          )
        : null,
  );

  ActivityHiveModel toHive() => ActivityHiveModel(
    id: id,
    memberId: memberId,
    nurseId: nurseId,
    description: description,
    date: date,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
    bloodPressure: bloodPressure,
    heartRate: heartRate,
    temperature: temperature,
    spo2: spo2,
    meals: meals,
    hydration: hydration,
    hygiene: hygiene,
    mobility: mobility,
    sleepQuality: sleepQuality,
    medication: medication,
    painLevel: painLevel,
    woundCondition: woundCondition,
    bowelBladder: bowelBladder,
    suppliesInventory: suppliesInventory,
    shiftSummary: shiftSummary,
    parentInstructions: parentInstructions,
    significantEvents: significantEvents,
    equipmentCheck: equipmentCheck,
    emergencyContactSync: emergencyContactSync,
    jointSignature: jointSignature,
  );

  static ActivityApiModel fromHive(ActivityHiveModel h) => ActivityApiModel(
    id: h.id,
    memberId: h.memberId,
    nurseId: h.nurseId,
    description: h.description,
    date: h.date,
    status: h.status,
    createdAt: h.createdAt,
    updatedAt: h.updatedAt,
    bloodPressure: h.bloodPressure,
    heartRate: h.heartRate,
    temperature: h.temperature,
    spo2: h.spo2,
    meals: h.meals,
    hydration: h.hydration,
    hygiene: h.hygiene,
    mobility: h.mobility,
    sleepQuality: h.sleepQuality,
    medication: h.medication,
    painLevel: h.painLevel,
    woundCondition: h.woundCondition,
    bowelBladder: h.bowelBladder,
    suppliesInventory: h.suppliesInventory,
    shiftSummary: h.shiftSummary,
    parentInstructions: h.parentInstructions,
    significantEvents: h.significantEvents,
    equipmentCheck: h.equipmentCheck,
    emergencyContactSync: h.emergencyContactSync,
    jointSignature: h.jointSignature,
  );
}
