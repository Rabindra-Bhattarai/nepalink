import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:nepalink/core/constants/hive_table_constants.dart';
import 'package:nepalink/features/dashboard/home/data/datasources/home_datasource.dart';
import 'package:nepalink/features/dashboard/home/data/models/activity_api_model.dart';
import 'package:nepalink/features/dashboard/home/data/models/activity_hive_model.dart';
import 'package:nepalink/features/dashboard/home/domain/entities/activity_entity.dart';

// Box name comes from HiveTableConstant.activityTable

final homeLocalDataSourceProvider = Provider<IHomeLocalDataSource>((ref) {
  return HomeLocalDataSource();
});

class HomeLocalDataSource implements IHomeLocalDataSource {
  Box<ActivityHiveModel> get _box =>
      Hive.box<ActivityHiveModel>(HiveTableConstant.activityTable);

  @override
  Future<List<ActivityEntity>> getAssignedActivities() async {
    return _box.values
        .map((h) => ActivityApiModel.fromHive(h).toEntity())
        .toList();
  }

  @override
  Future<void> saveActivities(List<ActivityEntity> activities) async {
    await _box.clear();
    for (final entity in activities) {
      final hive = ActivityHiveModel(
        id: entity.id,
        memberId: entity.memberId,
        nurseId: entity.nurseId,
        description: entity.description,
        date: entity.date,
        status: entity.status,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        bloodPressure: entity.vitalSigns?.bloodPressure,
        heartRate: entity.vitalSigns?.heartRate,
        temperature: entity.vitalSigns?.temperature,
        spo2: entity.vitalSigns?.spo2,
        meals: entity.dailyCare?.meals,
        hydration: entity.dailyCare?.hydration,
        hygiene: entity.dailyCare?.hygiene,
        mobility: entity.dailyCare?.mobility,
        sleepQuality: entity.dailyCare?.sleepQuality,
        medication: entity.medicalTracking?.medication,
        painLevel: entity.medicalTracking?.painLevel,
        woundCondition: entity.medicalTracking?.woundCondition,
        bowelBladder: entity.medicalTracking?.bowelBladder,
        suppliesInventory: entity.collaboration?.suppliesInventory,
        shiftSummary: entity.collaboration?.shiftSummary,
        parentInstructions: entity.collaboration?.parentInstructions,
        significantEvents: entity.collaboration?.significantEvents,
        equipmentCheck: entity.safetyVerification?.equipmentCheck,
        emergencyContactSync: entity.safetyVerification?.emergencyContactSync,
        jointSignature: entity.safetyVerification?.jointSignature,
      );
      await _box.put(entity.id, hive);
    }
  }

  @override
  Future<void> clearActivities() async {
    await _box.clear();
  }
}
