import 'package:dartz/dartz.dart';
import 'package:nepalink/core/errors/failures.dart';

/// Base interface for usecases that require parameters
abstract interface class UsecaseWithParms<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

/// Base interface for usecases that do not require parameters
abstract interface class UsecaseWithoutParms<SuccessType> {
  Future<Either<Failure, SuccessType>> call();
}
