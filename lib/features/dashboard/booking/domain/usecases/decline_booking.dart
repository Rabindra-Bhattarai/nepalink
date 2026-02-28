import '../repositories/booking_repository.dart';
import '../../data/models/booking_model.dart';

class DeclineBooking {
  final BookingRepository repository;

  DeclineBooking(this.repository);

  Future<BookingModel> call(String id) async {
    return await repository.declineBooking(id);
  }
}
