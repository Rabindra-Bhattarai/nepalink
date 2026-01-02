import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/usecases/app_usecases.dart';
import 'package:nepalink/features/auth/data/repositories/auth_repository.dart';
import 'package:nepalink/features/auth/domain/entities/user_entity.dart';
import 'package:nepalink/features/auth/domain/repositories/auth_repository.dart';

// Provider
final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GetCurrentUserUsecase(authRepository: authRepository);
});

class GetCurrentUserUsecase implements UsecaseWithoutParms<UserEntity?> {
  final IAuthRepository _authRepository;

  GetCurrentUserUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, UserEntity?>> call() {
    return _authRepository.getCurrentUser();
  }
}
