import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/usecases/app_usecases.dart';
import 'package:nepalink/features/dashboard/chat/data/repositories/chat_repository_impl.dart';
import 'package:nepalink/features/dashboard/chat/domain/repositories/chat_repository.dart';

class MarkReadParams {
  final String contractId;
  const MarkReadParams(this.contractId);
}

final markReadUsecaseProvider = Provider<MarkReadUsecase>((ref) {
  final repo = ref.read(chatRepositoryProvider);
  return MarkReadUsecase(repo);
});

class MarkReadUsecase implements UsecaseWithParms<bool, MarkReadParams> {
  final IChatRepository _repo;
  MarkReadUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(MarkReadParams params) {
    return _repo.markMessagesRead(params.contractId);
  }
}
