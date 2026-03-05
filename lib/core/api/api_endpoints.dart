import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Flip this flag depending on whether you're testing on a physical device or emulator
  static const bool isPhysicalDevice = true;
  static const String compIpAddress =
      "10.221.76.214"; // your PC IP for physical device

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else if (Platform.isAndroid) {
      // Emulator uses 10.0.2.2, physical device uses your PC IP
      return isPhysicalDevice
          ? 'http://$compIpAddress:3000/api'
          : 'http://10.0.2.2:3000/api';
    } else if (Platform.isIOS) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://localhost:3000/api';
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ====================== Auth Endpoints ======================
  static const String userSignup = '/auth/register';
  static const String userLogin = '/auth/login';

  // ====================== User Endpoints ======================
  static const String user = '/users';
  static String userById(String id) => '/users/$id';
  static String userUpload(String id) => '/users/$id/upload';

  // ====================== Booking Endpoints ======================
  static const String bookings = '/bookings';
  static String bookingAccept(String id) => '/bookings/$id/accept';
  static String bookingDecline(String id) => '/bookings/$id/decline';
  static String bookingCancel(String id) => '/bookings/$id/cancel';

  // ====================== Task / Activity Endpoints ======================
  static const String activities = '/activities';

  // Nurse: fetch assigned activities
  static const String activitiesAssigned = '/activities/assigned';

  // Member: fetch own activities
  static const String activitiesMy = '/activities/my';

  // Create new activity (task)
  static const String activityCreate = '/activities';

  // Update activity status
  static String activityUpdateStatus(String id) => '/activities/$id/status';

  // ====================== Chat Endpoints ======================
  /// Fetch all messages for a contract
  static String chatMessages(String contractId) => '/chat/$contractId';

  /// Send a new message in a contract
  static String chatSend(String contractId) => '/chat/$contractId/message';

  /// Mark messages as read for a contract
  static String chatMarkRead(String contractId) => '/chat/$contractId/read';
}
