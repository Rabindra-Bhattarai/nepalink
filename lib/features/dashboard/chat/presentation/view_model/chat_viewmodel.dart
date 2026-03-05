import 'package:flutter_riverpod/legacy.dart';

import 'package:nepalink/features/dashboard/chat/domain/entities/chat_entity.dart';
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

  /// Send a message with optimistic update:
  /// 1. Immediately append the message to the list (shows on screen instantly)
  /// 2. Call the API in the background
  /// 3. Replace the optimistic message with the real one from the server
  Future<void> sendMessage({
    required String contractId,
    required String receiverId,
    required String message,
    List<String>? attachments,
  }) async {
    // ── Step 1: Optimistic update ──
    // Create a temporary message with a local ID so it appears instantly
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final optimisticMessage = ChatMessageEntity(
      id: tempId,
      contractId: contractId,
      senderId: 'me',        // placeholder — only used for display
      receiverId: receiverId, // ✅ correct receiverId so isMe check works
      message: message,
      isRead: false,
      attachments: attachments,
      createdAt: DateTime.now(),
    );

    // Add to state immediately — user sees it on the right side instantly
    state = state.copyWith(
      status: ChatStatus.success,
      messages: [...state.messages, optimisticMessage],
    );

    // ── Step 2: Send to API ──
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
        // ── Step 3a: On failure — remove the optimistic message and show error ──
        state = state.copyWith(
          status: ChatStatus.failure,
          errorMessage: failure.message,
          messages: state.messages.where((m) => m.id != tempId).toList(),
        );
      },
      (sentMessage) {
        // ── Step 3b: On success — replace temp message with real server message ──
        final updatedMessages = state.messages
            .map((m) => m.id == tempId ? sentMessage : m)
            .toList();
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