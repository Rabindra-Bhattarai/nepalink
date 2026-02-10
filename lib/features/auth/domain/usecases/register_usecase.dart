import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/usecases/app_usecases.dart';
import 'package:nepalink/features/auth/domain/entities/user_entity.dart';
import 'package:nepalink/features/auth/domain/repositories/auth_repository.dart';
import 'package:nepalink/features/auth/data/repositories/auth_repository.dart';
import 'register_params.dart'; // ✅ import the params

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
      profilePic: params.profilePic,
      token: params.token,
      role: params.role ?? 'nurse',
    );

    return _authRepository.register(userEntity);
  }
}
