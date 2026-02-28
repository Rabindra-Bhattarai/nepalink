import '../repositories/booking_repository.dart';
import '../../data/models/booking_model.dart';

class AcceptBooking {
  final BookingRepository repository;

  AcceptBooking(this.repository);

  Future<BookingModel> call(String id) async {
    return await repository.acceptBooking(id);
  }
}
