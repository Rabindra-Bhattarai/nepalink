import 'package:flutter_riverpod/legacy.dart';
import 'package:nepalink/features/auth/domain/usecases/register_usecase.dart';
import 'package:nepalink/features/auth/domain/usecases/register_params.dart'; // ✅ import params separately
import 'package:nepalink/features/auth/domain/entities/user_entity.dart';
import 'package:nepalink/features/auth/presentation/state/register_state.dart';

class RegisterViewModel extends StateNotifier<RegisterState> {
  final RegisterUsecase _registerUsecase;

  RegisterViewModel(this._registerUsecase) : super(const RegisterState());

  Future<void> register(UserEntity user, String password) async {
    state = state.copyWith(status: RegisterStatus.loading);

    final params = RegisterParams(
      userid: user.userid,
      name: user.name,
      email: user.email,
      phone: user.phone ?? '',
      password: password.isNotEmpty ? password : (user.password ?? ''),
      profilePic: user.profilePic,
      token: user.token,
      role: user.role ?? 'nurse',
    );

    final result = await _registerUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: failure.message,
      ),
      (success) => state = state.copyWith(status: RegisterStatus.success),
    );
  }

  void reset() {
    state = const RegisterState(status: RegisterStatus.initial);
  }
}

final registerViewModelProvider =
    StateNotifierProvider<RegisterViewModel, RegisterState>((ref) {
      final usecase = ref.read(registerUsecaseProvider);
      return RegisterViewModel(usecase);
    });
