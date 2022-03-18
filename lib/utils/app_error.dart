class AppError {
  final String? errorMessage;
  final dynamic raw;
  final String? statusCode;

  AppError({this.errorMessage, this.statusCode, required this.raw});
}
