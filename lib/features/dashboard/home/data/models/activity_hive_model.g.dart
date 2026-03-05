// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityHiveModelAdapter extends TypeAdapter<ActivityHiveModel> {
  @override
  final int typeId = 5;

  @override
  ActivityHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityHiveModel(
      id: fields[0] as String,
      memberId: fields[1] as String,
      nurseId: fields[2] as String,
      description: fields[3] as String,
      date: fields[4] as DateTime,
      status: fields[5] as String,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
      bloodPressure: fields[8] as String?,
      heartRate: fields[9] as double?,
      temperature: fields[10] as double?,
      spo2: fields[11] as double?,
      meals: fields[12] as String?,
      hydration: fields[13] as String?,
      hygiene: fields[14] as String?,
      mobility: fields[15] as String?,
      sleepQuality: fields[16] as String?,
      medication: fields[17] as String?,
      painLevel: fields[18] as double?,
      woundCondition: fields[19] as String?,
      bowelBladder: fields[20] as String?,
      suppliesInventory: fields[21] as String?,
      shiftSummary: fields[22] as String?,
      parentInstructions: fields[23] as String?,
      significantEvents: fields[24] as String?,
      equipmentCheck: fields[25] as String?,
      emergencyContactSync: fields[26] as bool?,
      jointSignature: fields[27] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityHiveModel obj) {
    writer
      ..writeByte(28)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.memberId)
      ..writeByte(2)
      ..write(obj.nurseId)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.bloodPressure)
      ..writeByte(9)
      ..write(obj.heartRate)
      ..writeByte(10)
      ..write(obj.temperature)
      ..writeByte(11)
      ..write(obj.spo2)
      ..writeByte(12)
      ..write(obj.meals)
      ..writeByte(13)
      ..write(obj.hydration)
      ..writeByte(14)
      ..write(obj.hygiene)
      ..writeByte(15)
      ..write(obj.mobility)
      ..writeByte(16)
      ..write(obj.sleepQuality)
      ..writeByte(17)
      ..write(obj.medication)
      ..writeByte(18)
      ..write(obj.painLevel)
      ..writeByte(19)
      ..write(obj.woundCondition)
      ..writeByte(20)
      ..write(obj.bowelBladder)
      ..writeByte(21)
      ..write(obj.suppliesInventory)
      ..writeByte(22)
      ..write(obj.shiftSummary)
      ..writeByte(23)
      ..write(obj.parentInstructions)
      ..writeByte(24)
      ..write(obj.significantEvents)
      ..writeByte(25)
      ..write(obj.equipmentCheck)
      ..writeByte(26)
      ..write(obj.emergencyContactSync)
      ..writeByte(27)
      ..write(obj.jointSignature);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
