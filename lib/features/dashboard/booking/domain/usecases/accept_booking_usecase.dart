import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/features/dashboard/booking/data/repositories/booking_repository_provider.dart';
import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';
import 'package:nepalink/features/dashboard/booking/domain/repositories/booking_repository.dart';

final acceptBookingUsecaseProvider = Provider<AcceptBookingUsecase>((ref) {
  final repo = ref.read(bookingRepositoryProvider);
  return AcceptBookingUsecase(repo);
});

class AcceptBookingUsecase {
  final BookingRepository _repo;

  AcceptBookingUsecase(this._repo);

  Future<BookingEntity> call(String bookingId) {
    return _repo.acceptBooking(bookingId);
  }
}
