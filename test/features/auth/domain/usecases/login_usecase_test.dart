import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/auth/domain/entities/user_entity.dart';
import 'package:nepalink/features/auth/domain/repositories/auth_repository.dart';
import 'package:nepalink/features/auth/domain/usecases/login_usecase.dart';

@GenerateMocks([IAuthRepository])
import 'login_usecase_test.mocks.dart';

void main() {
  late LoginUsecase loginUsecase;
  late MockIAuthRepository mockAuthRepository;

  const tParams = LoginParams(
    email: 'kiran@gmail.com',
    password: 'password123',
  );

  const tUserEntity = UserEntity(
    userid: 'user-123',
    name: 'Kiran Rana',
    email: 'kiran@gmail.com',
    phone: '+9779876543210',
    password: 'password123',
    profilePic: null,
    token: 'jwt-token-abc',
    role: 'nurse',
  );

  setUp(() {
    mockAuthRepository = MockIAuthRepository();
    loginUsecase = LoginUsecase(authRepository: mockAuthRepository);
  });

  group('LoginUsecase', () {
    test('returns UserEntity when login is successful', () async {
      when(
        mockAuthRepository.login(any, any),
      ).thenAnswer((_) async => const Right(tUserEntity));

      final result = await loginUsecase(tParams);

      expect(result, const Right(tUserEntity));
      verify(
        mockAuthRepository.login('kiran@gmail.com', 'password123'),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('returns ApiFailure when credentials are wrong', () async {
      when(mockAuthRepository.login(any, any)).thenAnswer(
        (_) async =>
            const Left(ApiFailure(message: 'Invalid email or password')),
      );

      final result = await loginUsecase(tParams);

      expect(
        result,
        const Left(ApiFailure(message: 'Invalid email or password')),
      );
      verify(mockAuthRepository.login(any, any)).called(1);
    });
  });
}
