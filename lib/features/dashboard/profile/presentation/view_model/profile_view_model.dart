import 'dart:io';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nepalink/core/services/storage/user_session_service.dart';
import 'package:nepalink/features/dashboard/profile/domain/usecases/profile_usecases.dart';
import 'package:nepalink/features/dashboard/profile/presentation/state/profile_state.dart';

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>((ref) {
      return ProfileViewModel(
        getProfile: ref.read(getProfileUsecaseProvider),
        updateProfile: ref.read(updateProfileUsecaseProvider),
        uploadPicture: ref.read(uploadProfilePictureUsecaseProvider),
        logout: ref.read(logoutUsecaseProvider),
        sessionService: ref.read(userSessionServiceProvider), //
      );
    });

class ProfileViewModel extends StateNotifier<ProfileState> {
  final GetProfileUsecase _getProfile;
  final UpdateProfileUsecase _updateProfile;
  final UploadProfilePictureUsecase _uploadPicture;
  final LogoutUsecase _logout;
  final UserSessionService _sessionService;

  ProfileViewModel({
    required GetProfileUsecase getProfile,
    required UpdateProfileUsecase updateProfile,
    required UploadProfilePictureUsecase uploadPicture,
    required LogoutUsecase logout,
    required UserSessionService sessionService,
  }) : _getProfile = getProfile,
       _updateProfile = updateProfile,
       _uploadPicture = uploadPicture,
       _logout = logout,
       _sessionService = sessionService,
       super(const ProfileState());

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);

    // ✅ Read from SharedPreferences via UserSessionService
    final userId = _sessionService.getCurrentUserId();
    if (userId == null || userId.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'User not found. Please log in again.',
      );
      return;
    }

    final result = await _getProfile.call(userId);
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (profile) => state = state.copyWith(isLoading: false, profile: profile),
    );
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
  }) async {
    if (state.profile == null) return false;
    state = state.copyWith(isUpdating: true);

    final result = await _updateProfile.call(
      UpdateProfileParams(userId: state.profile!.id, name: name, phone: phone),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isUpdating: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (updated) {
        // ✅ Keep SharedPreferences in sync with updated name/phone
        _sessionService.saveUserSession(
          userId: updated.id,
          name: updated.name,
          email: updated.email,
          phone: updated.phone,
          password: _sessionService.getCurrentUserPassword() ?? '',
          profilePic: updated.imageUrl,
          token: _sessionService.getToken(),
          role: updated.role,
        );
        state = state.copyWith(
          isUpdating: false,
          profile: updated,
          successMessage: 'Profile updated successfully',
        );
        return true;
      },
    );
  }

  Future<bool> uploadProfilePicture(File image) async {
    if (state.profile == null) return false;
    state = state.copyWith(isUpdating: true);

    final result = await _uploadPicture.call(
      UploadPictureParams(userId: state.profile!.id, image: image),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isUpdating: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (updated) {
        // ✅ Keep profile pic in session in sync
        if (updated.imageUrl != null) {
          _sessionService.updateProfilePic(updated.imageUrl!);
        }
        state = state.copyWith(
          isUpdating: false,
          profile: updated,
          successMessage: 'Profile picture updated',
        );
        return true;
      },
    );
  }

  Future<bool> logout() async {
    final result = await _logout.call();
    return result.fold((_) => false, (_) {
      // ✅ Clear SharedPreferences session too
      _sessionService.clearSession();
      return true;
    });
  }
}
