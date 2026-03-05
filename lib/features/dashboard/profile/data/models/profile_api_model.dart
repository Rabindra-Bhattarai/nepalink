import 'package:nepalink/core/api/api_endpoints.dart';
import 'package:nepalink/features/dashboard/profile/domain/entities/profile_entity.dart';

class ProfileApiModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? imageUrl;
  final DateTime? createdAt;

  const ProfileApiModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.imageUrl,
    this.createdAt,
  });

  factory ProfileApiModel.fromJson(Map<String, dynamic> json) {
    return ProfileApiModel(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: (json['phone'] ?? '') as String,
      role: json['role'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  // Builds the full image URL from a filename stored on the backend
  String? get fullImageUrl {
    if (imageUrl == null || imageUrl == 'default-profile.png') return null;
    if (imageUrl!.startsWith('http')) return imageUrl;
    // Strip /api suffix to get base server URL
    final base = ApiEndpoints.baseUrl.replaceAll('/api', '');
    return '$base/uploads/$imageUrl';
  }

  ProfileEntity toEntity() => ProfileEntity(
    id: id,
    name: name,
    email: email,
    phone: phone,
    role: role,
    imageUrl: fullImageUrl,
    createdAt: createdAt,
  );
}
