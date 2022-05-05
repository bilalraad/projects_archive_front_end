import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password.g.dart';

@JsonSerializable(explicitToJson: true)
class ResetPassword {
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'token')
  final String token;
  @JsonKey(name: 'password')
  final String password;
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;
  ResetPassword({
    required this.email,
    required this.token,
    required this.password,
    required this.passwordConfirmation,
  });
  Map<String, dynamic> toJson() => _$ResetPasswordToJson(this);
}
