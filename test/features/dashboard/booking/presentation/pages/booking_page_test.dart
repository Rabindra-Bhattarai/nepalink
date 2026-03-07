import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nepalink/features/dashboard/booking/presentation/pages/booking_page.dart';
import 'package:nepalink/features/dashboard/booking/presentation/view_model/booking_view_model.dart';
import 'package:nepalink/features/dashboard/booking/presentation/state/booking_state.dart';

// Directly extends StateNotifier — no usecases, no repository, no crashes
class _StubBookingViewModel extends StateNotifier<BookingState>
    implements BookingViewModel {
  _StubBookingViewModel(BookingState initial) : super(initial);

  @override
  Future<void> loadBookings(String nurseId) async {}

  @override
  Future<void> accept(String bookingId) async {}

  @override
  Future<void> decline(String bookingId) async {}
}

Widget buildBookingPage(BookingState initialState) {
  return ProviderScope(
    overrides: [
      bookingViewModelProvider.overrideWith(
        (ref) => _StubBookingViewModel(initialState),
      ),
    ],
    child: const MaterialApp(home: BookingPage()),
  );
}

void main() {
  group('BookingPage widget tests', () {
    testWidgets('shows loading indicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildBookingPage(const BookingState(isLoading: true, bookings: [])),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when errorMessage is set', (tester) async {
      await tester.pumpWidget(
        buildBookingPage(
          const BookingState(
            isLoading: false,
            bookings: [],
            errorMessage: 'Server error occurred',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Server error occurred'), findsOneWidget);
    });

    testWidgets('shows empty ListView when bookings list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildBookingPage(const BookingState(isLoading: false, bookings: [])),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('shows RefreshIndicator wrapping content', (tester) async {
      await tester.pumpWidget(
        buildBookingPage(const BookingState(isLoading: false, bookings: [])),
      );
      await tester.pumpAndSettle();
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });
}
