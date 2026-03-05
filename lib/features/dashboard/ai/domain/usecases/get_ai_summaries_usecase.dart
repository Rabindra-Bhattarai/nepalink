import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/usecases/app_usecases.dart';
import 'package:nepalink/features/dashboard/ai/data/repositories/ai_repositories_impl.dart';
import 'package:nepalink/features/dashboard/ai/domain/entities/ai_entity.dart';
import 'package:nepalink/features/dashboard/ai/domain/repositories/ai_repositories.dart';

final getAiSummariesUsecaseProvider = Provider<GetAiSummariesUsecase>((ref) {
  return GetAiSummariesUsecase(repository: ref.read(aiRepositoryProvider));
});

class GetAiSummariesUsecase implements UsecaseWithoutParms<List<AiEntity>> {
  final IAiRepository _repo;
  GetAiSummariesUsecase({required IAiRepository repository})
    : _repo = repository;

  @override
  Future<Either<Failure, List<AiEntity>>> call() {
    return _repo.getAiSummaries();
  }
}
