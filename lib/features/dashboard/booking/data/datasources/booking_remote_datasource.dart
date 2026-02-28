import 'package:dio/dio.dart';
import 'package:nepalink/core/api/api_endpoints.dart';
import '../models/booking_model.dart';

class BookingRemoteDatasource {
  final Dio dio;

  BookingRemoteDatasource(this.dio);

  Future<List<BookingModel>> getMyBookings() async {
    final response = await dio.get(ApiEndpoints.bookings);
    return (response.data['data'] as List)
        .map((json) => BookingModel.fromJson(json))
        .toList();
  }

  Future<BookingModel> acceptBooking(String id) async {
    final response = await dio.put(ApiEndpoints.bookingAccept(id));
    return BookingModel.fromJson(response.data['data']['booking']);
  }

  Future<BookingModel> declineBooking(String id) async {
    final response = await dio.put(ApiEndpoints.bookingDecline(id));
    return BookingModel.fromJson(response.data['data']);
  }

  Future<BookingModel> cancelBooking(String id) async {
    final response = await dio.put(ApiEndpoints.bookingCancel(id));
    return BookingModel.fromJson(response.data['data']);
  }
}
