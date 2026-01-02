import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/usecases/app_usecases.dart';
import 'package:nepalink/features/auth/data/repositories/auth_repository.dart';
import 'package:nepalink/features/auth/domain/entities/user_entity.dart';
import 'package:nepalink/features/auth/domain/repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  final String userid;
  final String name;
  final String email;
  final String phone;
  final String password;

  const RegisterParams({
    required this.userid,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object?> get props => [userid, name, email, phone, password];
}

// Provider
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase implements UsecaseWithParms<bool, RegisterParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterParams params) {
    final userEntity = UserEntity(
      userid: params.userid,
      name: params.name,
      email: params.email,
      phone: params.phone,
      password: params.password,
    );

    return _authRepository.register(userEntity);
  }
}
