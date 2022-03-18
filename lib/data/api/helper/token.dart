import 'package:json_annotation/json_annotation.dart';

part "token.g.dart";

@JsonSerializable(explicitToJson: true)
class Tokens {
  @JsonKey(name: 'access')
  final String access;
  @JsonKey(name: 'refresh')
  final String refresh;

  Tokens({required this.access, required this.refresh});

  factory Tokens.fromJson(Map<String, dynamic> json) => _$TokensFromJson(json);

  Map<String, dynamic> toJson() => _$TokensToJson(this);
}
