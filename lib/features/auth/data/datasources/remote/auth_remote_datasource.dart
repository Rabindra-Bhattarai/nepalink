import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/api/api_client.dart';
import 'package:nepalink/core/api/api_endpoints.dart';
import 'package:nepalink/core/services/storage/user_session_service.dart';
import 'package:nepalink/features/auth/data/datasources/auth_datasource.dart';
import 'package:nepalink/features/auth/data/models/auth_api_model.dart';

final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;

  @override
  Future<UserApiModel> registerUser(UserApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.userSignup,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return UserApiModel.fromJson(data);
    }

    throw Exception(response.data['message'] ?? 'Failed to register user');
  }

  @override
  Future<UserApiModel?> loginUser(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.userLogin,
      data: {'email': email, 'password': password},
    );

    if (response.data['success'] == true) {
      final user = UserApiModel.fromLoginJson(response.data);

      await _userSessionService.saveUserSession(
        userId: user.id ?? '',
        email: user.email,
        name: user.name,
        phone: user.phone ?? '', // fixed
        password: '',
        token: user.token ?? '',
        profilePic: user.profilePic ?? '',
        role: user.role ?? 'nurse', // default nurse
      );

      return user;
    }

    return null;
  }

  @override
  Future<UserApiModel?> getCurrentUser() async {
    try {
      if (!_userSessionService.isLoggedIn()) return null;

      final userId = _userSessionService.getCurrentUserId();
      if (userId == null) return null;

      final response = await _apiClient.get(ApiEndpoints.userById(userId));

      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final currentUser = UserApiModel.fromJson(data);

        await _userSessionService.saveUserSession(
          userId: currentUser.id ?? '',
          email: currentUser.email,
          name: currentUser.name,
          phone: currentUser.phone ?? '', // fixed
          password: '',
          profilePic: currentUser.profilePic ?? '',
          token: _userSessionService.getToken() ?? '',
          role: currentUser.role ?? 'nurse', // default nurse
        );

        return currentUser;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> logoutUser() async {
    try {
      await _userSessionService.clearSession();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<UserApiModel?> uploadProfileImage(String userId, File photo) async {
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(
        photo.path,
        filename: photo.path.split('/').last,
      ),
    });

    final response = await _apiClient.post(
      ApiEndpoints.userUpload(userId),
      data: formData,
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final updatedUser = UserApiModel.fromJson(data);

      await _userSessionService.saveUserSession(
        userId: updatedUser.id ?? '',
        name: updatedUser.name,
        email: updatedUser.email,
        phone: updatedUser.phone ?? '', // ✅ fixed
        password: updatedUser.password ?? '',
        profilePic: updatedUser.profilePic ?? '',
        token: _userSessionService.getToken() ?? '',
        role: updatedUser.role ?? 'nurse', //  default nurse
      );

      return updatedUser;
    }

    return null;
  }
}
