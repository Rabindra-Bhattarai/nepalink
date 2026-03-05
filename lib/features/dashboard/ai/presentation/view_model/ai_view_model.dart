import 'package:flutter_riverpod/legacy.dart';
import 'package:nepalink/features/dashboard/ai/domain/usecases/get_ai_summaries_usecase.dart';
import 'package:nepalink/features/dashboard/ai/presentation/state/ai_state.dart';

final aiViewModelProvider = StateNotifierProvider<AiViewModel, AiState>((ref) {
  return AiViewModel(getAiSummaries: ref.read(getAiSummariesUsecaseProvider));
});

class AiViewModel extends StateNotifier<AiState> {
  final GetAiSummariesUsecase _getAiSummaries;

  AiViewModel({required GetAiSummariesUsecase getAiSummaries})
    : _getAiSummaries = getAiSummaries,
      super(const AiState()) {
    loadSummaries();
  }

  Future<void> loadSummaries() async {
    state = state.copyWith(isLoading: true);
    final result = await _getAiSummaries.call();
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (summaries) =>
          state = state.copyWith(isLoading: false, summaries: summaries),
    );
  }
}
