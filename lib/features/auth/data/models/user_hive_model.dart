import 'package:hive/hive.dart';
import 'package:nepalink/core/constants/hive_table_constants.dart';
import 'package:nepalink/features/auth/domain/entities/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTypeId)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String userid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String password;

  UserHiveModel({
    String? userid,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  }) : userid = userid ?? const Uuid().v4();

  /// Convert Hive model to domain entity
  UserEntity toEntity() {
    return UserEntity(
      userid: userid,
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
  }

  /// Create Hive model from domain entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userid: entity.userid,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      password: entity.password,
    );
  }

  /// Convert list of Hive models to list of domain entities
  static List<UserEntity> toEntityList(List<UserHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
