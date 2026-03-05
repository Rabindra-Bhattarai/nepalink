import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/providers/hive_provider.dart';
import 'package:nepalink/core/services/hive/hive_service.dart';
import 'package:nepalink/features/dashboard/booking/data/datasources/booking_datasource.dart';
import 'package:nepalink/features/dashboard/booking/data/models/booking_hive_model.dart';
import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';

final bookingLocalDatasourceProvider = Provider<BookingLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return BookingLocalDatasource(hiveService: hiveService);
});

class BookingLocalDatasource implements IBookingLocalDataSource {
  final HiveService _hiveService;

  BookingLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<List<BookingEntity>> getBookingsForNurse() async {
    final box = _hiveService.getBookingBox();
    return box.values.map((hiveModel) => hiveModel.toEntity()).toList();
  }

  // ✅ Added: fetch bookings for member
  Future<List<BookingEntity>> getBookingsForMember() async {
    final box = _hiveService.getBookingBox();
    return box.values.map((hiveModel) => hiveModel.toEntity()).toList();
  }

  @override
  Future<void> cacheBookings(List<BookingEntity> bookings) async {
    final box = _hiveService.getBookingBox();
    await box.clear();
    for (var booking in bookings) {
      await box.put(booking.id, BookingHiveModel.fromEntity(booking));
    }
  }

  @override
  Future<void> updateBookingStatus(String bookingId, String status) async {
    final box = _hiveService.getBookingBox();
    final booking = box.get(bookingId);
    if (booking != null) {
      final updated = booking.copyWith(status: status);
      await box.put(bookingId, updated);
    }
  }

  // ✅ Added: save a single booking (used in accept/decline/cancel flows)
  Future<void> saveBooking(BookingEntity booking) async {
    final box = _hiveService.getBookingBox();
    await box.put(booking.id, BookingHiveModel.fromEntity(booking));
  }
}
