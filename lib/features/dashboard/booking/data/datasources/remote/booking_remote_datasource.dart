import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepalink/core/api/api_client.dart';
import 'package:nepalink/core/api/api_endpoints.dart';
import 'package:nepalink/features/dashboard/booking/data/datasources/booking_datasource.dart';
import 'package:nepalink/features/dashboard/booking/domain/entities/booking_entity.dart';

final bookingRemoteDatasourceProvider = Provider<BookingRemoteDatasource>((
  ref,
) {
  final apiClient = ref.read(apiClientProvider);
  return BookingRemoteDatasource(apiClient: apiClient);
});

class BookingRemoteDatasource implements IBookingRemoteDataSource {
  final ApiClient _apiClient;

  BookingRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<BookingEntity>> getBookingsForNurse() async {
    final response = await _apiClient.get(ApiEndpoints.bookings);
    final data = response.data['data'] as List<dynamic>;
    return data.map((json) => BookingEntity.fromJson(json)).toList();
  }

  @override
  Future<BookingEntity> acceptBooking(String bookingId) async {
    final response = await _apiClient.put(
      ApiEndpoints.bookingAccept(bookingId),
    );
    final bookingJson = response.data['data']['booking']; // ✅ drill down
    return BookingEntity.fromJson(bookingJson);
  }

  @override
  Future<BookingEntity> declineBooking(String bookingId) async {
    final response = await _apiClient.put(
      ApiEndpoints.bookingDecline(bookingId),
    );
    final bookingJson = response.data['data']['booking']; // ✅ drill down
    return BookingEntity.fromJson(bookingJson);
  }
}
