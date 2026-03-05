import 'package:flutter_riverpod/legacy.dart';

import 'package:nepalink/features/dashboard/chat/domain/usecases/get_messages_usecase.dart';
import 'package:nepalink/features/dashboard/chat/domain/usecases/send_message_usecase.dart';
import 'package:nepalink/features/dashboard/chat/domain/usecases/mark_read_usecase.dart';
import 'package:nepalink/features/dashboard/chat/presentation/state/chat_state.dart';

final chatViewModelProvider = StateNotifierProvider<ChatViewModel, ChatState>((
  ref,
) {
  final getMessages = ref.read(getMessagesUsecaseProvider);
  final sendMessage = ref.read(sendMessageUsecaseProvider);
  final markRead = ref.read(markReadUsecaseProvider);

  return ChatViewModel(
    getMessagesUsecase: getMessages,
    sendMessageUsecase: sendMessage,
    markReadUsecase: markRead,
  );
});

class ChatViewModel extends StateNotifier<ChatState> {
  final GetMessagesUsecase _getMessagesUsecase;
  final SendMessageUsecase _sendMessageUsecase;
  final MarkReadUsecase _markReadUsecase;

  ChatViewModel({
    required GetMessagesUsecase getMessagesUsecase,
    required SendMessageUsecase sendMessageUsecase,
    required MarkReadUsecase markReadUsecase,
  }) : _getMessagesUsecase = getMessagesUsecase,
       _sendMessageUsecase = sendMessageUsecase,
       _markReadUsecase = markReadUsecase,
       super(const ChatState());

  /// Load all messages for a contract
  Future<void> loadMessages(String contractId) async {
    state = state.copyWith(status: ChatStatus.loading, errorMessage: null);
    final result = await _getMessagesUsecase(GetMessagesParams(contractId));
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ChatStatus.failure,
          errorMessage: failure.message,
        );
      },
      (messages) {
        state = state.copyWith(status: ChatStatus.success, messages: messages);
      },
    );
  }

  /// Send a new message
  Future<void> sendMessage({
    required String contractId,
    required String receiverId,
    required String message,
    List<String>? attachments,
  }) async {
    final result = await _sendMessageUsecase(
      SendMessageParams(
        contractId: contractId,
        receiverId: receiverId,
        message: message,
        attachments: attachments,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ChatStatus.failure,
          errorMessage: failure.message,
        );
      },
      (sentMessage) {
        final updatedMessages = [...state.messages, sentMessage];
        state = state.copyWith(
          status: ChatStatus.success,
          messages: updatedMessages,
        );
      },
    );
  }

  /// Mark messages as read
  Future<void> markMessagesRead(String contractId) async {
    final result = await _markReadUsecase(MarkReadParams(contractId));
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ChatStatus.failure,
          errorMessage: failure.message,
        );
      },
      (_) {
        final updatedMessages = state.messages
            .map((msg) => msg.copyWith(isRead: true))
            .toList();
        state = state.copyWith(messages: updatedMessages);
      },
    );
  }
}
