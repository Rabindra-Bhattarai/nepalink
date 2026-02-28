import '../datasources/booking_remote_datasource.dart';
import '../models/booking_model.dart';
import '../../domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDatasource datasource;

  BookingRepositoryImpl(this.datasource);

  @override
  Future<List<BookingModel>> getMyBookings() => datasource.getMyBookings();

  @override
  Future<BookingModel> acceptBooking(String id) => datasource.acceptBooking(id);

  @override
  Future<BookingModel> declineBooking(String id) =>
      datasource.declineBooking(id);

  @override
  Future<BookingModel> cancelBooking(String id) => datasource.cancelBooking(id);
}
