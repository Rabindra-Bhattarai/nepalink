import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:nepalink/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/auth/domain/repositories/auth_repository.dart';

// Simple Failure class
class SimpleFailure extends Failure {
  SimpleFailure(String message) : super(message);
}

// Fake repository for testing
class FakeAuthRepository implements IAuthRepository {
  @override
  Future<Either<Failure, bool>> logout() async {
    // Simulate success
    return Right(true);
  }

  // Other methods not needed for this test
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late LogoutUsecase logoutUsecase;

  setUp(() {
    logoutUsecase = LogoutUsecase(authRepository: FakeAuthRepository());
  });

  test("Logout succeeds", () async {
    final result = await logoutUsecase.call();
    expect(result.isRight(), true);
  });

  test("Logout fails", () async {
    // Override FakeAuthRepository to simulate failure
    final failingRepo = _FailingAuthRepository();
    final failingUsecase = LogoutUsecase(authRepository: failingRepo);

    final result = await failingUsecase.call();
    expect(result.isLeft(), true);
  });
}

// A failing repository for the second test
class _FailingAuthRepository implements IAuthRepository {
  @override
  Future<Either<Failure, bool>> logout() async {
    return Left(SimpleFailure("Logout failed"));
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
