// import 'package:flutter_riverpod/legacy.dart';
// import 'package:nepalink/features/auth/domain/usecases/logout_usecase.dart';
// import 'package:nepalink/features/auth/presentation/state/logout_state.dart';
// import 'package:nepalink/core/services/storage/user_session_service.dart';

// class LogoutViewModel extends StateNotifier<LogoutState> {
//   final LogoutUsecase _logoutUsecase;
//   final UserSessionService _sessionService;

//   LogoutViewModel(this._logoutUsecase, this._sessionService)
//     : super(const LogoutState());

//   Future<void> logout() async {
//     state = state.copyWith(status: LogoutStatus.loading);

//     final result = await _logoutUsecase();

//     result.fold(
//       (failure) {
//         state = state.copyWith(
//           status: LogoutStatus.failure,
//           errorMessage: failure.message,
//         );
//       },
//       (success) async {
//         // ✅ Clear local session so SplashScreen sees user as logged out
//         await _sessionService.clearSession();

//         state = state.copyWith(status: LogoutStatus.success);
//       },
//     );
//   }
// }

// // Provider
// final logoutViewModelProvider =
//     StateNotifierProvider<LogoutViewModel, LogoutState>((ref) {
//       final usecase = ref.read(logoutUsecaseProvider);
//       final sessionService = ref.read(userSessionServiceProvider);
//       return LogoutViewModel(usecase, sessionService);
//     });
