import 'package:nepalink/core/services/connectivity/network_info.dart';
import 'package:nepalink/features/dashboard/booking/data/datasources/local/booking_local_datasource.dart';
import 'package:nepalink/features/dashboard/booking/data/datasources/remote/booking_remote_datasource.dart';
import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';
import 'package:nepalink/features/dashboard/booking/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDatasource _remote;
  final BookingLocalDatasource _local;
  final NetworkInfo _networkInfo;

  BookingRepositoryImpl({
    required BookingRemoteDatasource remoteDatasource,
    required BookingLocalDatasource localDatasource,
    required NetworkInfo networkInfo,
  }) : _remote = remoteDatasource,
       _local = localDatasource,
       _networkInfo = networkInfo;

  @override
  Future<List<BookingEntity>> getBookingsForNurse(String nurseId) async {
    if (await _networkInfo.isConnected) {
      // ✅ Fetch from API
      final bookings = await _remote.getBookingsForNurse();
      // ✅ Cache locally
      await _local.cacheBookings(bookings);
      return bookings;
    } else {
      // ✅ Offline fallback
      return await _local.getBookingsForNurse();
    }
  }

  @override
  Future<BookingEntity> acceptBooking(String bookingId) async {
    if (await _networkInfo.isConnected) {
      final booking = await _remote.acceptBooking(bookingId);
      await _local.updateBookingStatus(bookingId, booking.status);
      return booking;
    } else {
      // Offline: just update local status
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
      // Offline: just update local status
      await _local.updateBookingStatus(bookingId, 'declined');
      final offlineBookings = await _local.getBookingsForNurse();
      return offlineBookings.firstWhere((b) => b.id == bookingId);
    }
  }
}
