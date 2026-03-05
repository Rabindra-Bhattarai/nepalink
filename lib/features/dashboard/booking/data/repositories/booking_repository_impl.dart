import 'package:nepalink/core/services/connectivity/network_info.dart';
import 'package:nepalink/features/dashboard/booking/data/datasources/booking_datasource.dart';
import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';
import 'package:nepalink/features/dashboard/booking/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final IBookingRemoteDataSource _remote;
  final IBookingLocalDataSource _local;
  final NetworkInfo _networkInfo;

  BookingRepositoryImpl({
    required IBookingRemoteDataSource remoteDatasource,
    required IBookingLocalDataSource localDatasource,
    required NetworkInfo networkInfo,
  }) : _remote = remoteDatasource,
       _local = localDatasource,
       _networkInfo = networkInfo;

  @override
  Future<List<BookingEntity>> getBookingsForNurse(String nurseId) async {
    if (await _networkInfo.isConnected) {
      final bookings = await _remote.getBookingsForNurse();
      await _local.cacheBookings(bookings);
      return bookings;
    } else {
      return await _local.getBookingsForNurse();
    }
  }

  @override
  Future<BookingEntity> acceptBooking(String bookingId) async {
    if (await _networkInfo.isConnected) {
      // Remote returns { booking, contract }
      final response = await _remote.acceptBooking(bookingId);

      final booking = response['booking'] as BookingEntity;
      final contractJson = response['contract'];

      // ✅ Use copyWith to patch contractId immutably
      final updatedBooking =
          (contractJson != null && contractJson['_id'] != null)
          ? booking.copyWith(contractId: contractJson['_id'].toString())
          : booking;

      await _local.updateBookingStatus(bookingId, updatedBooking.status);
      return updatedBooking;
    } else {
      await _local.updateBookingStatus(bookingId, 'accepted');
      final offlineBookings = await _local.getBookingsForNurse();
      return offlineBookings.firstWhere((b) => b.id == bookingId);
    }
  }

  @override
  Future<BookingEntity> declineBooking(String bookingId) async {
    if (await _networkInfo.isConnected) {
      final booking = await _remote.declineBooking(bookingId);
      await _local.updateBookingStatus(bookingId, booking.status);
      return booking;
    } else {
      await _local.updateBookingStatus(bookingId, 'declined');
      final offlineBookings = await _local.getBookingsForNurse();
      return offlineBookings.firstWhere((b) => b.id == bookingId);
    }
  }
}
