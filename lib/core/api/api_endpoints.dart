// import 'dart:io';

// import 'package:flutter/foundation.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = true; // flip when needed
  static const String compIpAddress = "10.238.15.214";

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

  // static const bool isPhysicalDevice = true; // flip when needed
  // static const String compIpAddress = "172.25.0.222";

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth Endpoints
  static const String userSignup = '/auth/register';
  static const String userLogin = '/auth/login';

  // User Endpoints
  static const String user = '/users';
  static String userById(String id) => '/users/$id';
  static String userUpload(String id) => '/users/$id/upload';

  // Booking Endpoints
  static const String bookings = '/bookings';
  static String bookingAccept(String id) => '/bookings/$id/accept';
  static String bookingDecline(String id) => '/bookings/$id/decline';
  static String bookingCancel(String id) => '/bookings/$id/cancel';
}
