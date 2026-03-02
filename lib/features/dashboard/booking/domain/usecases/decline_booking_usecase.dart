import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/features/dashboard/booking/data/repositories/booking_repository_provider.dart';
import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';
import 'package:nepalink/features/dashboard/booking/domain/repositories/booking_repository.dart';

final declineBookingUsecaseProvider = Provider<DeclineBookingUsecase>((ref) {
  final repo = ref.read(bookingRepositoryProvider);
  return DeclineBookingUsecase(repo);
});

class DeclineBookingUsecase {
  final BookingRepository _repo;

  DeclineBookingUsecase(this._repo);

  Future<BookingEntity> call(String bookingId) {
    return _repo.declineBooking(bookingId);
  }
}
