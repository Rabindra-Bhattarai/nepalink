import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/usecases/app_usecases.dart';
import 'package:nepalink/features/dashboard/chat/data/repositories/chat_repository_impl.dart';
import 'package:nepalink/features/dashboard/chat/domain/entities/chat_entity.dart';
import 'package:nepalink/features/dashboard/chat/domain/repositories/chat_repository.dart';

class GetMessagesParams {
  final String contractId;
  const GetMessagesParams(this.contractId);
}

final getMessagesUsecaseProvider = Provider<GetMessagesUsecase>((ref) {
  final repo = ref.read(chatRepositoryProvider);
  return GetMessagesUsecase(repo);
});

class GetMessagesUsecase
    implements UsecaseWithParms<List<ChatMessageEntity>, GetMessagesParams> {
  final IChatRepository _repo;
  GetMessagesUsecase(this._repo);

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> call(
    GetMessagesParams params,
  ) {
    return _repo.getMessages(params.contractId);
  }
}
