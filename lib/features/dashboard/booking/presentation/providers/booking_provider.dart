import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nepalink/core/api/api_client.dart';
import 'package:nepalink/features/dashboard/booking/data/models/booking_model.dart';

import '../../data/datasources/booking_remote_datasource.dart';
import '../../data/repositories/booking_repository_impl.dart';

final bookingProvider =
    StateNotifierProvider<BookingNotifier, AsyncValue<List<BookingModel>>>((
      ref,
    ) {
      final dio = ref.read(apiClientProvider).dio;
      final datasource = BookingRemoteDatasource(dio);
      final repository = BookingRepositoryImpl(datasource);
      return BookingNotifier(repository);
    });

class BookingNotifier extends StateNotifier<AsyncValue<List<BookingModel>>> {
  final BookingRepositoryImpl repository;

  BookingNotifier(this.repository) : super(const AsyncValue.loading()) {
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      final bookings = await repository.getMyBookings();
      state = AsyncValue.data(bookings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> acceptBooking(String id) async {
    await repository.acceptBooking(id);
    fetchBookings();
  }

  Future<void> declineBooking(String id) async {
    await repository.declineBooking(id);
    fetchBookings();
  }

  Future<void> cancelBooking(String id) async {
    await repository.cancelBooking(id);
    fetchBookings();
  }
}
