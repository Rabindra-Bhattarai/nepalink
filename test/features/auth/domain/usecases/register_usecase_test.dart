import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:nepalink/features/auth/domain/usecases/register_usecase.dart';
import 'package:nepalink/features/auth/domain/entities/user_entity.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/auth/domain/repositories/auth_repository.dart';

// Simple Failure class
class SimpleFailure extends Failure {
  SimpleFailure(String message) : super(message);
}

// Fake repository for testing
class FakeAuthRepository implements IAuthRepository {
  @override
  Future<Either<Failure, bool>> register(UserEntity user) async {
    if (user.email == "newuser@example.com") {
      return Right(true);
    } else {
      return Left(SimpleFailure("Email already exists"));
    }
  }

  // Other methods not needed for this test
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late RegisterUsecase registerUsecase;

  setUp(() {
    registerUsecase = RegisterUsecase(authRepository: FakeAuthRepository());
  });

  test("Register succeeds with valid user", () async {
    final result = await registerUsecase.call(
      const RegisterParams(
        userid: "2",
        name: "New User",
        email: "newuser@example.com",
        phone: "9876543210",
        password: "securepass",
      ),
    );

    expect(result.isRight(), true);
  });

  test("Register fails with existing email", () async {
    final result = await registerUsecase.call(
      const RegisterParams(
        userid: "3",
        name: "Existing User",
        email: "existing@example.com",
        phone: "9876543210",
        password: "securepass",
      ),
    );

    expect(result.isLeft(), true);
  });
}
