import '../../data/models/booking_model.dart';

abstract class BookingRepository {
  Future<List<BookingModel>> getMyBookings();
  Future<BookingModel> acceptBooking(String id);
  Future<BookingModel> declineBooking(String id);
  Future<BookingModel> cancelBooking(String id);
}
