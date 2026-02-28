import '../repositories/booking_repository.dart';
import '../../data/models/booking_model.dart';

class GetMyBookings {
  final BookingRepository repository;

  GetMyBookings(this.repository);

  Future<List<BookingModel>> call() async {
    return await repository.getMyBookings();
  }
}
