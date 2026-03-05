import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nepalink/features/dashboard/booking/presentation/pages/booking_page.dart';
import 'package:nepalink/features/dashboard/chat/presentation/screens/chat_screen.dart';


class ChatTab extends ConsumerStatefulWidget {
  const ChatTab({super.key});

  @override
  ConsumerState<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends ConsumerState<ChatTab> {
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      // Load the real user ID from JWT at the same time as bookings
      await _loadCurrentUserId();
      ref.read(bookingViewModelProvider.notifier).loadBookings(_currentUserId);
    });
  }

  /// Decodes the stored JWT and extracts the user's _id
  Future<void> _loadCurrentUserId() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) return;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return;

      // Fix base64 padding then decode
      String payload = parts[1];
      switch (payload.length % 4) {
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }

      final decoded = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> jsonPayload = jsonDecode(decoded);

      // 🔍 This print tells you EXACTLY what field name your backend uses for the ID
      debugPrint('✅ JWT payload: $jsonPayload');

      // Tries the most common field names — check the print above to confirm yours
      final id =
          jsonPayload['id']?.toString() ??
          jsonPayload['_id']?.toString() ??
          jsonPayload['userId']?.toString() ??
          jsonPayload['sub']?.toString() ??
          '';

      debugPrint('✅ currentUserId resolved to: "$id"');

      if (mounted) setState(() => _currentUserId = id);
    } catch (e) {
      debugPrint('❌ JWT decode error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingViewModelProvider);

    final acceptedBookings = state.bookings
        .where((b) => b.status == 'accepted' && b.contractId.isNotEmpty)
        .toList();

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2A9D7A)),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: Color(0xFFDDE3EF),
            ),
            const SizedBox(height: 12),
            Text(
              state.errorMessage!,
              style: const TextStyle(color: Color(0xFF9DAAB8), fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (acceptedBookings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9F5),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 38,
                  color: Color(0xFF2A9D7A),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "No active care chats",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Accept a booking to unlock secure messaging with your patient.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9DAAB8),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Care Chats",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E2A38),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "${acceptedBookings.length} active ${acceptedBookings.length == 1 ? 'conversation' : 'conversations'}",
                style: const TextStyle(fontSize: 13, color: Color(0xFF9DAAB8)),
              ),
            ],
          ),
        ),
        Container(height: 1, color: const Color(0xFFEAEEF4)),

        // Chat list
        Expanded(
          child: RefreshIndicator(
            color: const Color(0xFF2A9D7A),
            onRefresh: () async {
              await _loadCurrentUserId();
              await ref
                  .read(bookingViewModelProvider.notifier)
                  .loadBookings(_currentUserId);
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: acceptedBookings.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 74,
                endIndent: 0,
                color: Color(0xFFEAEEF4),
              ),
              itemBuilder: (context, index) {
                final booking = acceptedBookings[index];
                return _ChatListTile(
                  booking: booking,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          contractId: booking.contractId,
                          receiverId: booking.memberId,
                          // ✅ Real user ID decoded from JWT
                          currentUserId: _currentUserId,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatListTile extends StatelessWidget {
  final dynamic booking;
  final VoidCallback onTap;

  const _ChatListTile({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFEAEEF4),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.5),
                    child: booking.profilePic.isNotEmpty
                        ? Image.network(
                            booking.profilePic,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _defaultAvatar(),
                          )
                        : _defaultAvatar(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A9D7A),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        booking.memberName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E2A38),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A9D7A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "New",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Active Care Contract',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9DAAB8)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFB0BAC9),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: const Color(0xFFE8F4F0),
      child: const Icon(
        Icons.person_rounded,
        color: Color(0xFF2A9D7A),
        size: 26,
      ),
    );
  }
}
