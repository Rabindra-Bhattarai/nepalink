import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';

abstract interface class IBookingLocalDataSource {
  Future<List<BookingEntity>> getBookingsForNurse();
  Future<void> cacheBookings(List<BookingEntity> bookings);
  Future<void> updateBookingStatus(String bookingId, String status);
}

abstract interface class IBookingRemoteDataSource {
  Future<List<BookingEntity>> getBookingsForNurse();
  Future<Map<String, dynamic>> acceptBooking(String bookingId);
  Future<BookingEntity> declineBooking(String bookingId);
}
