import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';

/// Contract for booking repository
abstract interface class BookingRepository {
  /// Fetch all bookings for a nurse
  Future<List<BookingEntity>> getBookingsForNurse(String nurseId);

  /// Accept a booking
  Future<BookingEntity> acceptBooking(String bookingId);

  /// Decline a booking
  Future<BookingEntity> declineBooking(String bookingId);
}
