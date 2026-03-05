import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/core/usecases/app_usecases.dart';
import 'package:nepalink/features/dashboard/chat/data/repositories/chat_repository_impl.dart';
import 'package:nepalink/features/dashboard/chat/domain/entities/chat_entity.dart';
import 'package:nepalink/features/dashboard/chat/domain/repositories/chat_repository.dart';

class SendMessageParams {
  final String contractId;
  final String receiverId;
  final String message;
  final List<String>? attachments;

  const SendMessageParams({
    required this.contractId,
    required this.receiverId,
    required this.message,
    this.attachments,
  });
}

final sendMessageUsecaseProvider = Provider<SendMessageUsecase>((ref) {
  final repo = ref.read(chatRepositoryProvider);
  return SendMessageUsecase(repo);
});

class SendMessageUsecase
    implements UsecaseWithParms<ChatMessageEntity, SendMessageParams> {
  final IChatRepository _repo;
  SendMessageUsecase(this._repo);

  @override
  Future<Either<Failure, ChatMessageEntity>> call(SendMessageParams params) {
    return _repo.sendMessage(
      contractId: params.contractId,
      receiverId: params.receiverId,
      message: params.message,
      attachments: params.attachments,
    );
  }
}
