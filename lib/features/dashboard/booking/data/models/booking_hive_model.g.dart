// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingHiveModelAdapter extends TypeAdapter<BookingHiveModel> {
  @override
  final int typeId = 2;

  @override
  BookingHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingHiveModel(
      id: fields[0] as String,
      memberId: fields[1] as String,
      nurseId: fields[2] as String,
      contractId: fields[3] as String,
      memberName: fields[4] as String,
      memberPhone: fields[5] as String,
      profilePic: fields[6] as String,
      bookingDate: fields[7] as DateTime,
      status: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookingHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.memberId)
      ..writeByte(2)
      ..write(obj.nurseId)
      ..writeByte(3)
      ..write(obj.contractId)
      ..writeByte(4)
      ..write(obj.memberName)
      ..writeByte(5)
      ..write(obj.memberPhone)
      ..writeByte(6)
      ..write(obj.profilePic)
      ..writeByte(7)
      ..write(obj.bookingDate)
      ..writeByte(8)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
