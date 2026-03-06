import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/ai/data/datasources/remote/ai_remote_datasources.dart';
import 'package:nepalink/features/dashboard/ai/domain/entities/ai_entity.dart';
import 'package:nepalink/features/dashboard/ai/domain/repositories/ai_repositories.dart';

final aiRepositoryProvider = Provider<IAiRepository>((ref) {
  return AiRepositoryImpl(
    remoteDataSource: ref.read(aiRemoteDataSourceProvider),
  );
});

class AiRepositoryImpl implements IAiRepository {
  final AiRemoteDataSource _remote;
  AiRepositoryImpl({required AiRemoteDataSource remoteDataSource})
    : _remote = remoteDataSource;

  @override
  Future<Either<Failure, List<AiEntity>>> getAiSummaries() async {
    try {
      final models = await _remote.getAiSummaries();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
