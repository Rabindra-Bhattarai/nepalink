import 'package:hive/hive.dart';
import 'package:nepalink/core/constants/hive_table_constants.dart';
import 'package:nepalink/features/dashboard/profile/domain/entities/profile_entity.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.profileTypeId)
class ProfileHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String role;

  @HiveField(5)
  final String? imageUrl;

  ProfileHiveModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.imageUrl,
  });

  ProfileEntity toEntity() => ProfileEntity(
    id: id,
    name: name,
    email: email,
    phone: phone,
    role: role,
    imageUrl: imageUrl,
  );

  factory ProfileHiveModel.fromEntity(ProfileEntity entity) => ProfileHiveModel(
    id: entity.id,
    name: entity.name,
    email: entity.email,
    phone: entity.phone,
    role: entity.role,
    imageUrl: entity.imageUrl,
  );
}
