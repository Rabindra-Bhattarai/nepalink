import 'package:nepalink/features/dashboard/chat/domain/entities/chat_entity.dart';

abstract interface class IChatLocalDataSource {
  Future<void> saveMessage(ChatMessageEntity message);
  Future<List<ChatMessageEntity>> getMessages(String contractId);
  Future<void> markMessagesRead(String contractId);
}

abstract interface class IChatRemoteDataSource {
  Future<List<ChatMessageEntity>> getMessages(String contractId);
  Future<ChatMessageEntity> sendMessage({
    required String contractId,
    required String receiverId,
    required String message,
    List<String>? attachments,
  });
  Future<bool> markMessagesRead(String contractId);
}
