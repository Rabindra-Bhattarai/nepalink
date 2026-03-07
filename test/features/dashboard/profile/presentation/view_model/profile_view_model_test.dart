import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:nepalink/core/services/storage/user_session_service.dart';
import 'package:nepalink/features/dashboard/profile/domain/entities/profile_entity.dart';
import 'package:nepalink/features/dashboard/profile/domain/usecases/profile_usecases.dart';
import 'package:nepalink/features/dashboard/profile/presentation/view_model/profile_view_model.dart';

@GenerateMocks([
  GetProfileUsecase,
  UpdateProfileUsecase,
  UploadProfilePictureUsecase,
  LogoutUsecase,
  UserSessionService,
])
import 'profile_view_model_test.mocks.dart';

void main() {
  late ProfileViewModel profileViewModel;
  late MockGetProfileUsecase mockGetProfile;
  late MockUpdateProfileUsecase mockUpdateProfile;
  late MockUploadProfilePictureUsecase mockUploadPicture;
  late MockLogoutUsecase mockLogout;
  late MockUserSessionService mockSessionService;

  const tProfile = ProfileEntity(
    id: 'user-001',
    name: 'Kiran Rana',
    email: 'kiran@gmail.com',
    phone: '+9779800000001',
    role: 'nurse',
    imageUrl: null,
  );

  setUp(() {
    mockGetProfile = MockGetProfileUsecase();
    mockUpdateProfile = MockUpdateProfileUsecase();
    mockUploadPicture = MockUploadProfilePictureUsecase();
    mockLogout = MockLogoutUsecase();
    mockSessionService = MockUserSessionService();

    profileViewModel = ProfileViewModel(
      getProfile: mockGetProfile,
      updateProfile: mockUpdateProfile,
      uploadPicture: mockUploadPicture,
      logout: mockLogout,
      sessionService: mockSessionService,
    );
  });

  tearDown(() {
    profileViewModel.dispose();
  });

  group('ProfileViewModel', () {
    test('loads profile successfully when user id exists', () async {
      when(mockSessionService.getCurrentUserId()).thenReturn('user-001');
      when(
        mockGetProfile.call(any),
      ).thenAnswer((_) async => const Right(tProfile));

      await profileViewModel.loadProfile();

      expect(profileViewModel.state.profile, tProfile);
      expect(profileViewModel.state.isLoading, false);
      expect(profileViewModel.state.errorMessage, isNull);
    });

    test('sets errorMessage when no user id found in session', () async {
      when(mockSessionService.getCurrentUserId()).thenReturn(null);

      await profileViewModel.loadProfile();

      expect(
        profileViewModel.state.errorMessage,
        'User not found. Please log in again.',
      );
      expect(profileViewModel.state.profile, isNull);
    });

    test('updates profile and syncs session on success', () async {
      profileViewModel = ProfileViewModel(
        getProfile: mockGetProfile,
        updateProfile: mockUpdateProfile,
        uploadPicture: mockUploadPicture,
        logout: mockLogout,
        sessionService: mockSessionService,
      );

      const updatedProfile = ProfileEntity(
        id: 'user-001',
        name: 'Kiran Updated',
        email: 'kiran@gmail.com',
        phone: '+9779800000002',
        role: 'nurse',
      );

      when(mockSessionService.getCurrentUserId()).thenReturn('user-001');
      when(
        mockGetProfile.call(any),
      ).thenAnswer((_) async => const Right(tProfile));
      when(
        mockUpdateProfile.call(any),
      ).thenAnswer((_) async => const Right(updatedProfile));
      when(mockSessionService.getCurrentUserPassword()).thenReturn('pass123');
      when(mockSessionService.getToken()).thenReturn('token-abc');
      when(
        mockSessionService.saveUserSession(
          userId: anyNamed('userId'),
          name: anyNamed('name'),
          email: anyNamed('email'),
          phone: anyNamed('phone'),
          password: anyNamed('password'),
          profilePic: anyNamed('profilePic'),
          token: anyNamed('token'),
          role: anyNamed('role'),
        ),
      ).thenAnswer((_) async {});

      await profileViewModel.loadProfile();
      final result = await profileViewModel.updateProfile(
        name: 'Kiran Updated',
        phone: '+9779800000002',
      );

      expect(result, true);
      expect(profileViewModel.state.profile?.name, 'Kiran Updated');
      expect(
        profileViewModel.state.successMessage,
        'Profile updated successfully',
      );
    });

    test('logout clears session and returns true on success', () async {
      when(mockLogout.call()).thenAnswer((_) async => const Right(null));
      when(mockSessionService.clearSession()).thenAnswer((_) async {});

      final result = await profileViewModel.logout();

      expect(result, true);
      verify(mockSessionService.clearSession()).called(1);
    });
  });
}
