import 'package:flutter/foundation.dart';

class AppError {
  final String? errorMessage;
  final dynamic raw;
  final dynamic stack;

  final String? statusCode;

  AppError({
    this.errorMessage,
    this.statusCode,
    required this.stack,
    required this.raw,
  }) {
    if (kDebugMode) {
      final error = "StartError" +
          '===================================================' +
          raw +
          "===================================================" +
          stack +
          "===================================================" +
          'EndError';
      print(error);
    }
  }
}
