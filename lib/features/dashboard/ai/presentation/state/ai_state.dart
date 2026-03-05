import 'package:equatable/equatable.dart';
import 'package:nepalink/features/dashboard/ai/domain/entities/ai_entity.dart';

class AiState extends Equatable {
  final List<AiEntity> summaries;
  final bool isLoading;
  final String? errorMessage;

  const AiState({
    this.summaries = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AiState copyWith({
    List<AiEntity>? summaries,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AiState(
      summaries: summaries ?? this.summaries,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [summaries, isLoading, errorMessage];
}
