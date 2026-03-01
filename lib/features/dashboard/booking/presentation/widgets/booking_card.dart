import 'package:flutter/material.dart';
import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';

class BookingCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: booking.profilePic.isNotEmpty
                  ? NetworkImage(booking.profilePic)
                  : null,
              child: booking.profilePic.isEmpty
                  ? const Icon(Icons.person, size: 30)
                  : null,
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.memberName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    booking.memberPhone,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "Date: ${booking.bookingDate.toLocal()}",
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Chip(
                    label: Text(booking.status.toUpperCase()),
                    backgroundColor: _statusColor(booking.status),
                  ),
                ],
              ),
            ),

            if (booking.status == 'pending') ...[
              IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: onAccept,
              ),
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: onDecline,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green.shade200;
      case 'declined':
        return Colors.red.shade200;
      case 'cancelled':
        return Colors.grey.shade300;
      default:
        return Colors.orange.shade200; // pending
    }
  }
}
