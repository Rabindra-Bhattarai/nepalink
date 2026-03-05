import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({
    Key? key,
    required this.controller,
    required this.onSend,
  }) : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEAEEF4), width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Text input
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FB),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFFDDE3EF),
                      width: 1.2,
                    ),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1E2A38),
                    ),
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: TextStyle(
                        color: Color(0xFFB0BAC9),
                        fontSize: 15,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Send button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: _hasText
                      ? const LinearGradient(
                          colors: [Color(0xFF2A9D7A), Color(0xFF1E7D61)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: _hasText ? null : const Color(0xFFEAEEF4),
                  borderRadius: BorderRadius.circular(23),
                  boxShadow: _hasText
                      ? [
                          BoxShadow(
                            color: const Color(0xFF2A9D7A).withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(23),
                    onTap: _hasText ? widget.onSend : null,
                    child: Center(
                      child: Icon(
                        Icons.send_rounded,
                        size: 20,
                        color: _hasText
                            ? Colors.white
                            : const Color(0xFFB0BAC9),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
