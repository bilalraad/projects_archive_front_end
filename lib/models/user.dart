import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.g.dart';
part 'user.freezed.dart';

@freezed
class User with _$User {
  factory User({
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'name') required String name,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static User fromJsonModel(dynamic json) => User.fromJson(json);
}
