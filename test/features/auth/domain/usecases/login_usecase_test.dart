import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:nepalink/features/auth/domain/usecases/login_usecase.dart';
import 'package:nepalink/features/auth/domain/entities/user_entity.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/auth/domain/repositories/auth_repository.dart';

// A simple concrete Failure class for testing
class SimpleFailure extends Failure {
  SimpleFailure(String message) : super(message);
}

// Simple fake repository
class FakeAuthRepository implements IAuthRepository {
  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    if (email == "test@example.com" && password == "123456") {
      return Right(
        UserEntity(
          userid: "1",
          email: email,
          name: '',
          phone: '',
          password: '',
        ),
      );
    } else {
      return Left(SimpleFailure("Invalid credentials"));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> register(UserEntity user) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> uploadProfileImage(
    String userId,
    File photo,
  ) {
    // TODO: implement uploadProfileImage
    throw UnimplementedError();
  }
}

void main() {
  late LoginUsecase loginUsecase;

  setUp(() {
    loginUsecase = LoginUsecase(authRepository: FakeAuthRepository());
  });

  test("Login succeeds with correct email and password", () async {
    final result = await loginUsecase.call(
      const LoginParams(email: "test@example.com", password: "123456"),
    );

    expect(result.isRight(), true);
  });

  test("Login fails with wrong email or password", () async {
    final result = await loginUsecase.call(
      const LoginParams(email: "wrong@example.com", password: "wrong"),
    );

    expect(result.isLeft(), true);
  });
}
