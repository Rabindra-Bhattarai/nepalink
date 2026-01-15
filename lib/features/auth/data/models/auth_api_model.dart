import 'package:nepalink/features/auth/domain/entities/user_entity.dart';

class UserApiModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String password;


  UserApiModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,

  });

  /// Convert API model to JSON (for sending data to server)
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,

    };
  }

  /// Create API model from JSON (for receiving data from server)
  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,

    );
  }

  /// Convert API model to domain entity
  UserEntity toEntity() {
    return UserEntity(
      userid: id ?? '',
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
  }

  /// Create API model from domain entity
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      password: entity.password,
    );
  }

 
}
