import 'package:flutter/foundation.dart';
import 'package:projects_archiving/data/api/helper/network_exceptions.dart';

class AppError {
  final String? errorMessage;
  final dynamic raw;
  final dynamic stack;
  AppError({
    this.errorMessage,
    required this.stack,
    required this.raw,
  }) {
    if (kDebugMode) {
      final error = "\nStartError"
              '\n===================================================\n' +
          raw.toString() +
          "\n===================================================\n" +
          stack.toString() +
          "\n===================================================\n" +
          'EndError\n';
      print(error);
    }
  }

  String get readableMessage =>
      NetworkExceptions.getFilteredException(raw).getErrorMessage();
}
