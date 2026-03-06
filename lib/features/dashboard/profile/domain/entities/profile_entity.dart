import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? imageUrl;
  final DateTime? createdAt;

  const ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.imageUrl,
    this.createdAt,
  });

  ProfileEntity copyWith({
    String? name,
    String? email,
    String? phone,
    String? imageUrl,
  }) {
    return ProfileEntity(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, role, imageUrl];
}
