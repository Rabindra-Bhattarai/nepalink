import 'package:flutter/material.dart';
import 'package:nepalink/features/dashboard/chat/domain/entities/chat_entity.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isMe;

  const MessageBubble({Key? key, required this.message, required this.isMe})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('hh:mm a');
    final screenWidth = MediaQuery.of(context).size.width;

    // The inner bubble row (avatar + bubble + timestamp).
    // mainAxisSize.min means it ONLY takes up as much width as it needs —
    // this is what allows Align below to actually push it left or right.
    final Widget bubbleRow = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // ── RECEIVED: avatar on the LEFT ──
        if (!isMe)
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 8, bottom: 18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5BA4CF), Color(0xFF3A7FBF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),

        // ── BUBBLE + TIMESTAMP ──
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: screenWidth * 0.62),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  gradient: isMe
                      ? const LinearGradient(
                          colors: [Color(0xFF2A9D7A), Color(0xFF1E7D61)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isMe ? null : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isMe ? 18 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isMe
                          ? const Color(0xFF2A9D7A).withOpacity(0.22)
                          : Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: isMe
                      ? null
                      : Border.all(color: const Color(0xFFEAEEF4), width: 1),
                ),
                child: Text(
                  message.message,
                  style: TextStyle(
                    color: isMe ? Colors.white : const Color(0xFF2C3E50),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),

              // Timestamp + read receipt
              Padding(
                padding: EdgeInsets.only(
                  top: 3,
                  left: isMe ? 0 : 4,
                  right: isMe ? 4 : 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeFormat.format(message.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFAAB4C2),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.done_all_rounded,
                        size: 14,
                        color: Color(0xFF2A9D7A),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // ── THE FIX ──
    // Align widget fills available width by default, then positions
    // the child (bubbleRow) to centerRight or centerLeft.
    // Row with MainAxisAlignment.end does NOT work reliably here because
    // ConstrainedBox/Column children don't force the Row to fill full width.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: bubbleRow,
      ),
    );
  }
}
