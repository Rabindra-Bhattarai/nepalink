import 'package:hive/hive.dart';
import '../../../../core/constants/hive_table_constants.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTypeId)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String countryCode;

  @HiveField(5)
  final String password; // stored locally for now

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.countryCode,
    required this.password,
  });

  /// Convert to domain entity
  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    email: email,
    phone: phone,
    countryCode: countryCode,
  );

  /// Create from domain entity
  factory UserModel.fromEntity(UserEntity entity, String password) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      countryCode: entity.countryCode,
      password: password,
    );
  }
}
