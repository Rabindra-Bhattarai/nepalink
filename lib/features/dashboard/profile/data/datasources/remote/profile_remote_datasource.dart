import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/api/api_client.dart';
import 'package:nepalink/core/api/api_endpoints.dart';
import 'package:nepalink/features/dashboard/profile/data/datasources/profile_datasource.dart';
import 'package:nepalink/features/dashboard/profile/data/models/profile_api_model.dart';

final profileRemoteDataSourceProvider = Provider<IProfileRemoteDataSource>((
  ref,
) {
  return ProfileRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

class ProfileRemoteDataSource implements IProfileRemoteDataSource {
  final ApiClient _apiClient;

  ProfileRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  /// GET /api/users/:id
  @override
  Future<ProfileApiModel> getProfile(String userId) async {
    final response = await _apiClient.get(ApiEndpoints.userById(userId));
    return ProfileApiModel.fromJson(response.data['data']);
  }

  /// PUT /api/users/:id
  @override
  Future<ProfileApiModel> updateProfile({
    required String userId,
    required String name,
    required String phone,
  }) async {
    final response = await _apiClient.put(
      ApiEndpoints.userById(userId),
      data: {'name': name, 'phone': phone},
    );
    return ProfileApiModel.fromJson(response.data['data']);
  }

  /// POST /api/users/:id/upload — field name must match multer: "photo"
  @override
  Future<ProfileApiModel> uploadProfilePicture({
    required String userId,
    required File image,
  }) async {
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });
    final response = await _apiClient.uploadFile(
      ApiEndpoints.userUpload(userId),
      formData: formData,
    );
    return ProfileApiModel.fromJson(response.data['data']);
  }
}
