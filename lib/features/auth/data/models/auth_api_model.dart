import 'package:nepalink/features/auth/domain/entities/user_entity.dart';

class UserApiModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? password;
  final String? token; // <-- capture JWT

  UserApiModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.password,
    this.token,
  });

  /// Convert API model to JSON (for sending data to server)
  Map<String, dynamic> toJson() {
    return {"name": name, "email": email, "phone": phone, "password": password};
  }

  /// For registration responses (direct user JSON)
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String?,
    );
  }

  /// For login responses (user inside "data", token at root)
  factory UserApiModel.fromLoginJson(Map<String, dynamic> json) {
    final userJson = json['data'] as Map<String, dynamic>;
    return UserApiModel(
      id: userJson['_id'] as String?,
      name: userJson['name'] as String,
      email: userJson['email'] as String,
      phone: userJson['phone'] as String,
      token: json['token'] as String?, // ✅ capture JWT
    );
  }

  /// Convert API model to domain entity
  UserEntity toEntity() {
    return UserEntity(
      userid: id ?? '',
      name: name,
      email: email,
      phone: phone,
      password: password ?? '',
      token: token, // ✅ now valid because UserEntity has token
    );
  }

  /// Create API model from domain entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      id: entity.userid,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      password: entity.password,
      token: entity.token, // ✅ now valid
    );
  }
}
