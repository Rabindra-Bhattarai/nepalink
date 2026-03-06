// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskHiveModelAdapter extends TypeAdapter<TaskHiveModel> {
  @override
  final int typeId = 3;

  @override
  TaskHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskHiveModel(
      id: fields[0] as String?,
      memberId: fields[1] as String,
      nurseId: fields[2] as String,
      description: fields[3] as String,
      date: fields[4] as DateTime,
      status: fields[5] as String,
      vitalSigns: (fields[6] as Map?)?.cast<String, String>(),
      dailyCare: (fields[7] as Map?)?.cast<String, String>(),
      medicalTracking: (fields[8] as Map?)?.cast<String, String>(),
      collaboration: (fields[9] as Map?)?.cast<String, String>(),
      safetyVerification: (fields[10] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, TaskHiveModel obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.vitalSigns)
      ..writeByte(7)
      ..write(obj.dailyCare)
      ..writeByte(8)
      ..write(obj.medicalTracking)
      ..writeByte(9)
      ..write(obj.collaboration)
      ..writeByte(10)
      ..write(obj.safetyVerification);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
