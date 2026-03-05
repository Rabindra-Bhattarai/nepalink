import 'package:flutter_riverpod/legacy.dart';

import 'package:nepalink/features/dashboard/booking/domain/usecases/get_booking_for_nurse_usecase.dart';
import 'package:nepalink/features/dashboard/booking/domain/usecases/accept_booking_usecase.dart';
import 'package:nepalink/features/dashboard/booking/domain/usecases/decline_booking_usecase.dart';
import 'package:nepalink/features/dashboard/booking/presentation/state/booking_state.dart';

class BookingViewModel extends StateNotifier<BookingState> {
  final GetBookingsForNurseUsecase _getBookingsForNurse;
  final AcceptBookingUsecase _acceptBooking;
  final DeclineBookingUsecase _declineBooking;

  BookingViewModel({
    required GetBookingsForNurseUsecase getBookingsForNurse,
    required AcceptBookingUsecase acceptBooking,
    required DeclineBookingUsecase declineBooking,
  }) : _getBookingsForNurse = getBookingsForNurse,
       _acceptBooking = acceptBooking,
       _declineBooking = declineBooking,
       super(BookingState.initial());

  /// Load bookings for a nurse
  Future<void> loadBookings(String nurseId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final bookings = await _getBookingsForNurse.call(nurseId);
      state = state.copyWith(isLoading: false, bookings: bookings);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Accept a booking
  Future<void> accept(String bookingId) async {
    try {
      final updated = await _acceptBooking.call(bookingId);
      final updatedList = state.bookings.map((b) {
        return b.id == bookingId ? updated : b;
      }).toList();
      state = state.copyWith(bookings: updatedList);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// Decline a booking
  Future<void> decline(String bookingId) async {
    try {
      final updated = await _declineBooking.call(bookingId);
      final updatedList = state.bookings.map((b) {
        return b.id == bookingId ? updated : b;
      }).toList();
      state = state.copyWith(bookings: updatedList);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }
}
