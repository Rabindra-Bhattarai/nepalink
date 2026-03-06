import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nepalink/features/dashboard/booking/domain/usecases/get_booking_for_nurse_usecase.dart';
import 'package:nepalink/features/dashboard/booking/presentation/view_model/booking_view_model.dart';
import 'package:nepalink/features/dashboard/booking/presentation/state/booking_state.dart';
import 'package:nepalink/features/dashboard/booking/presentation/widgets/booking_card.dart';
import 'package:nepalink/features/dashboard/booking/domain/usecases/accept_booking_usecase.dart';
import 'package:nepalink/features/dashboard/booking/domain/usecases/decline_booking_usecase.dart';

final bookingViewModelProvider =
    StateNotifierProvider<BookingViewModel, BookingState>((ref) {
      final getBookings = ref.read(getBookingsForNurseUsecaseProvider);
      final acceptBooking = ref.read(acceptBookingUsecaseProvider);
      final declineBooking = ref.read(declineBookingUsecaseProvider);

      return BookingViewModel(
        getBookingsForNurse: getBookings,
        acceptBooking: acceptBooking,
        declineBooking: declineBooking,
      );
    });

class BookingPage extends ConsumerWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookingViewModelProvider);
    final viewModel = ref.read(bookingViewModelProvider.notifier);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.loadBookings(
            "nurse-id",
          ); // replace with actual nurseId
        },
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.errorMessage != null
            ? Center(child: Text("Error: ${state.errorMessage}"))
            : ListView.builder(
                itemCount: state.bookings.length,
                itemBuilder: (context, index) {
                  final booking = state.bookings[index];
                  return BookingCard(
                    booking: booking,
                    onAccept: () => viewModel.accept(booking.id),
                    onDecline: () => viewModel.decline(booking.id),
                  );
                },
              ),
      ),
    );
  }
}
