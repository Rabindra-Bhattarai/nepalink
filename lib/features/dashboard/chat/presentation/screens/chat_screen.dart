import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nepalink/features/dashboard/chat/presentation/state/chat_state.dart';
import 'package:nepalink/features/dashboard/chat/presentation/view_model/chat_viewmodel.dart';
import 'package:nepalink/features/dashboard/chat/presentation/widgets/message_bubble.dart';
import 'package:nepalink/features/dashboard/chat/presentation/widgets/chat_input_field.dart';
import 'package:nepalink/features/dashboard/chat/presentation/widgets/chat_header.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String contractId;
  final String receiverId;
  final String currentUserId; // ← ADD THIS: the logged-in user's real ID

  const ChatScreen({
    Key? key,
    required this.contractId,
    required this.receiverId,
    required this.currentUserId, // ← ADD THIS
  }) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(chatViewModelProvider.notifier).loadMessages(widget.contractId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    ref
        .read(chatViewModelProvider.notifier)
        .sendMessage(
          contractId: widget.contractId,
          receiverId: widget.receiverId,
          message: text,
        );

    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: ChatHeader(
        title: "Care Chat",
        onMarkRead: () {
          ref
              .read(chatViewModelProvider.notifier)
              .markMessagesRead(widget.contractId);
        },
      ),
      body: Column(
        children: [
          // Message list
          Expanded(
            child: state.status == ChatStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2A9D7A)),
                  )
                : state.status == ChatStatus.failure
                ? _buildErrorState(state.errorMessage)
                : state.messages.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    color: const Color(0xFF2A9D7A),
                    onRefresh: () async {
                      await ref
                          .read(chatViewModelProvider.notifier)
                          .loadMessages(widget.contractId);
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];

                        // isMe: nurse sent it if receiverId is the member (widget.receiverId)
                        // .contains() handles edge case where ID is inside a stringified object
                        final isMe = msg.receiverId.contains(widget.receiverId);

                        final showDate =
                            index == 0 ||
                            !_isSameDay(
                              state.messages[index - 1].createdAt,
                              msg.createdAt,
                            );

                        return Column(
                          children: [
                            if (showDate) _buildDateSeparator(msg.createdAt),
                            MessageBubble(message: msg, isMe: isMe),
                          ],
                        );
                      },
                    ),
                  ),
          ),

          ChatInputField(controller: _messageController, onSend: _sendMessage),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    String label;
    if (_isSameDay(date, now)) {
      label = "Today";
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      label = "Yesterday";
    } else {
      label = "${date.day} ${_monthName(date.month)} ${date.year}";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(
            child: Divider(color: Color(0xFFDDE3EF), thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9DAAB8),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const Expanded(
            child: Divider(color: Color(0xFFDDE3EF), thickness: 1),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F4F0),
              borderRadius: BorderRadius.circular(36),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 34,
              color: Color(0xFF2A9D7A),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "No messages yet",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3D4A5C),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Send a message to start the conversation",
            style: TextStyle(fontSize: 13, color: Color(0xFF9DAAB8)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Color(0xFFE07070),
          ),
          const SizedBox(height: 12),
          Text(
            message ?? "Something went wrong",
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7A8D)),
          ),
        ],
      ),
    );
  }
}
