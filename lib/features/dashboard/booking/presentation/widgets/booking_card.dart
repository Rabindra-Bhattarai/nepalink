import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/booking_model.dart';
import '../providers/booking_provider.dart';

class BookingCard extends ConsumerWidget {
  final BookingModel booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(bookingProvider.notifier);

    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text("Member: ${booking.member.name}"),
        subtitle: Text("Date: ${booking.date.toLocal()}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => notifier.acceptBooking(booking.id),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => notifier.declineBooking(booking.id),
            ),
          ],
        ),
      ),
    );
  }
}
