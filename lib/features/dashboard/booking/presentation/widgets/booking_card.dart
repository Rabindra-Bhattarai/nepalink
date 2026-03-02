import 'package:flutter/material.dart';
import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';
import 'package:intl/intl.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getGradientColors(booking.status),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _statusColor(booking.status).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _statusColor(booking.status).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Profile picture with status indicator
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _statusColor(booking.status),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _statusColor(
                                booking.status,
                              ).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundImage: booking.profilePic.isNotEmpty
                              ? NetworkImage(booking.profilePic)
                              : null,
                          backgroundColor: _statusColor(
                            booking.status,
                          ).withOpacity(0.2),
                          child: booking.profilePic.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 36,
                                  color: _statusColor(booking.status),
                                )
                              : null,
                        ),
                      ),
                      if (booking.status == 'pending')
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Member info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.memberName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_rounded,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              booking.memberPhone,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(booking.status),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _statusColor(booking.status).withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _statusText(booking.status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Date and time info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: _statusColor(booking.status),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appointment Date',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat(
                              'EEE, MMM dd, yyyy',
                            ).format(booking.bookingDate.toLocal()),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.access_time_rounded,
                      size: 20,
                      color: _statusColor(booking.status),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat(
                        'hh:mm a',
                      ).format(booking.bookingDate.toLocal()),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ],
                ),
              ),

              // Action buttons for pending bookings
              if (booking.status == 'pending') ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onDecline,
                        icon: const Icon(Icons.close_rounded, size: 20),
                        label: const Text(
                          'Decline',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red[600],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.red[300]!, width: 2),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onAccept,
                        icon: const Icon(Icons.check_rounded, size: 20),
                        label: const Text(
                          'Accept',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: Colors.green.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(String status) {
    switch (status) {
      case 'accepted':
        return [Colors.green[100]!, Colors.green[50]!];
      case 'declined':
        return [Colors.red[100]!, Colors.red[50]!];
      case 'cancelled':
        return [Colors.grey[200]!, Colors.grey[100]!];
      default:
        return [Colors.orange[100]!, Colors.orange[50]!];
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green[600]!;
      case 'declined':
        return Colors.red[600]!;
      case 'cancelled':
        return Colors.grey[600]!;
      default:
        return Colors.orange[600]!;
    }
  }

  String _statusText(String status) {
    switch (status) {
      case 'accepted':
        return '✓ ACCEPTED';
      case 'declined':
        return '✕ DECLINED';
      case 'cancelled':
        return 'CANCELLED';
      default:
        return '⏱ PENDING';
    }
  }
}
