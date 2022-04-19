import 'package:json_annotation/json_annotation.dart';

part 'laravel_validation_error.g.dart';

@JsonSerializable()
class LaravelValdiationError {
  final String message;
  final int code;
  final List<FeildsError> errors;

  LaravelValdiationError(this.message, this.code, this.errors);

  factory LaravelValdiationError.fromJson(Map<String, dynamic> json) =>
      _$LaravelValdiationErrorFromJson(json);
}

@JsonSerializable()
class FeildsError {
  final String field;
  final String message;

  FeildsError(this.field, this.message);

  factory FeildsError.fromJson(Map<String, dynamic> json) =>
      _$FeildsErrorFromJson(json);
}
