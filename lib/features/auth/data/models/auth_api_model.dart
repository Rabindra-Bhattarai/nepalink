import 'package:nepalink/features/auth/domain/entities/user_entity.dart';

class UserApiModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? password;
  final String? profilePic; // maps backend imageUrl
  final String? token; // capture JWT

  UserApiModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.password,
    this.profilePic,
    this.token,
  });

  /// Convert API model to JSON (for sending data to server)
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "imageUrl": profilePic, // backend expects imageUrl
    };
  }

  /// For registration responses (direct user JSON)
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String?,
      profilePic: json['imageUrl'] as String?, //  map imageUrl
      token: json['token'] as String?,
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
      password: userJson['password'] as String?,
      profilePic: userJson['imageUrl'] as String?, // ✅ map imageUrl
      token: json['token'] as String?,
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
      profilePic: profilePic, //  now consistent
      token: token,
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
      profilePic: entity.profilePic, //  consistent
      token: entity.token,
    );
  }
}
