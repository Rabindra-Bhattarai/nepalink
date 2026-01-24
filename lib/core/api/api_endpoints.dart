import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  //static const String baseUrl = 'http://localhost:3000/api';
  // static const String baseUrl = 'http://192.168.1.5:3000/api';

  //static const String baseUrl = 'http://10.0.2.2:3000/api';
  // static const String baseUrl = 'http://192.168.1.100:3000/api';

  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:5000/api/v1'

  static const bool isPhysicalDevice =
      true; // Set to true when testing on physical device

  static const String compIpAddress = "192.168.1.5";

  static String get baseUrl {
    if (isPhysicalDevice) {
      return 'http://$compIpAddress:3000/api/v1';
    }
    // yadi android
    if (kIsWeb) {
      return 'http://localhost:3000/api/v1';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000/api/v1';
    } else if (Platform.isIOS) {
      return 'http://localhost:3000/api/v1';
    } else {
      return 'http://localhost:3000/api/v1';
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  //Auth Endpoints,,
  static const String userSignup = '/auth/register';
  static const String userLogin = '/auth/login';

  //User Endpoinys
  static const String user = '/users';
  static String userById(String id) => '/users/$id';
}
