import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';

class BookingState {
  final bool isLoading;
  final List<BookingEntity> bookings;
  final String? errorMessage;

  const BookingState({
    required this.isLoading,
    required this.bookings,
    this.errorMessage,
  });

  /// Initial state
  factory BookingState.initial() {
    return const BookingState(
      isLoading: false,
      bookings: [],
      errorMessage: null,
    );
  }

  /// Copy state with new values
  BookingState copyWith({
    bool? isLoading,
    List<BookingEntity>? bookings,
    String? errorMessage,
  }) {
    return BookingState(
      isLoading: isLoading ?? this.isLoading,
      bookings: bookings ?? this.bookings,
      errorMessage: errorMessage,
    );
  }
}
