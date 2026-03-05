import 'package:dartz/dartz.dart';
import 'package:nepalink/core/errors/failures.dart';
import 'package:nepalink/features/dashboard/chat/domain/entities/chat_entity.dart';

abstract interface class IChatRepository {
  Future<Either<Failure, List<ChatMessageEntity>>> getMessages(
    String contractId,
  );
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String contractId,
    required String receiverId,
    required String message,
    List<String>? attachments,
  });
  Future<Either<Failure, bool>> markMessagesRead(String contractId);
}
