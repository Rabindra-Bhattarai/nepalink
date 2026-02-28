import '../repositories/booking_repository.dart';
import '../../data/models/booking_model.dart';

class CancelBooking {
  final BookingRepository repository;

  CancelBooking(this.repository);

  Future<BookingModel> call(String id) async {
    return await repository.cancelBooking(id);
  }
}
