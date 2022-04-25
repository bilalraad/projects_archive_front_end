import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:projects_archiving/models/laravel_validation_error.dart';

part 'network_exceptions.freezed.dart';

@freezed
class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  const factory NetworkExceptions.httpError(Response response) = HttpError;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  static NetworkExceptions getFilteredException(error) {
    if (error is Exception) {
      try {
        NetworkExceptions networkExceptions;
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              networkExceptions = const NetworkExceptions.requestCancelled();
              break;
            case DioErrorType.connectTimeout:
              networkExceptions = const NetworkExceptions.requestTimeout();
              break;
            case DioErrorType.receiveTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioErrorType.response:
              networkExceptions = NetworkExceptions.httpError(error.response!);
              break;
            case DioErrorType.sendTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioErrorType.other:
              networkExceptions =
                  const NetworkExceptions.noInternetConnection();
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = const NetworkExceptions.noInternetConnection();
        } else {
          networkExceptions = const NetworkExceptions.unexpectedError();
        }
        return networkExceptions;
      } on FormatException catch (_) {
        return const NetworkExceptions.formatException();
      } catch (_) {
        return const NetworkExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return const NetworkExceptions.unableToProcess();
      } else {
        return const NetworkExceptions.unexpectedError();
      }
    }
  }
}

extension NetworkErrorHandler on NetworkExceptions {
  String getErrorMessage() {
    var errorMessage = "";
    when(
      requestCancelled: () {
        errorMessage = 'تم الغاء العملية';
      },
      httpError: (Response response) {
        if (response.statusCode == 422) {
          errorMessage = LaravelValdiationError.fromJson(response.data)
              .errors
              .first
              .message;
        }
        if (response.statusCode == 404) {
          errorMessage = response.data;
        } else {
          errorMessage = 'حدث خطأ غير متوقع';
        }
      },
      unexpectedError: () {
        errorMessage = 'حدث خطأ غير متوقع';
      },
      requestTimeout: () {
        errorMessage = 'فشل في الاتصال';
      },
      noInternetConnection: () {
        errorMessage = 'لا يوجد اتصال بالانترنت';
      },
      sendTimeout: () {
        errorMessage = 'فشل في الاتصال الرجاء المحاولة لاحقا';
      },
      unableToProcess: () {
        if (kDebugMode) {
          errorMessage = "Unable to process the data backend error";
        } else {
          errorMessage = 'حدث خطأ غير متوقع الرجاء الابلاغ عنه';
        }
      },
      formatException: () {
        errorMessage = 'حدث خطأ غير متوقع الرجاء الابلاغ عنه';
      },
    );
    return errorMessage;
  }
}
