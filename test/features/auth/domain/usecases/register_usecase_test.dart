import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/auth/domain/repositories/auth_repository.dart';
import 'package:nepalink/features/auth/domain/usecases/register_usecase.dart';
import 'package:nepalink/features/auth/domain/usecases/register_params.dart';

@GenerateMocks([IAuthRepository])
import 'register_usecase_test.mocks.dart';

void main() {
  late RegisterUsecase registerUsecase;
  late MockIAuthRepository mockAuthRepository;

  const tParams = RegisterParams(
    userid: 'user-123',
    name: 'Kiran Rana',
    email: 'kiran@gmail.com',
    phone: '+9779876543210',
    password: 'password123',
    profilePic: null,
    token: null,
    role: 'nurse',
  );

  setUp(() {
    mockAuthRepository = MockIAuthRepository();
    registerUsecase = RegisterUsecase(authRepository: mockAuthRepository);
  });

  group('RegisterUsecase', () {
    test('returns true when registration is successful', () async {
      when(
        mockAuthRepository.register(any),
      ).thenAnswer((_) async => const Right(true));

      final result = await registerUsecase(tParams);

      expect(result, const Right(true));
      verify(mockAuthRepository.register(any)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('returns ApiFailure when email already exists', () async {
      when(mockAuthRepository.register(any)).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Email already exists')),
      );

      final result = await registerUsecase(tParams);

      expect(result, const Left(ApiFailure(message: 'Email already exists')));
      verify(mockAuthRepository.register(any)).called(1);
    });
  });
}
