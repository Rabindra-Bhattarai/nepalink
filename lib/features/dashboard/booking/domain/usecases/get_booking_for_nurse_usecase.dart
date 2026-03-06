import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/features/dashboard/booking/data/repositories/booking_repository_provider.dart';
import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';
import 'package:nepalink/features/dashboard/booking/domain/repositories/booking_repository.dart';

final getBookingsForNurseUsecaseProvider = Provider<GetBookingsForNurseUsecase>(
  (ref) {
    final repo = ref.read(bookingRepositoryProvider);
    return GetBookingsForNurseUsecase(repo);
  },
);

class GetBookingsForNurseUsecase {
  final BookingRepository _repo;

  GetBookingsForNurseUsecase(this._repo);

  Future<List<BookingEntity>> call(String nurseId) {
    return _repo.getBookingsForNurse(nurseId);
  }
}
