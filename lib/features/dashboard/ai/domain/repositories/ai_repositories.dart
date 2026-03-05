import 'package:dartz/dartz.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/ai/domain/entities/ai_entity.dart';

abstract interface class IAiRepository {
  Future<Either<Failure, List<AiEntity>>> getAiSummaries();
}
