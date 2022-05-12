import 'package:json_annotation/json_annotation.dart';
import 'package:projects_archiving/utils/enums.dart';

part 'graduate.g.dart';

@JsonSerializable()
class Graduate {
  @JsonKey(name: 'name_ar')
  final String name;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'level')
  final Level level;
  Graduate({required this.level, required this.name, required this.id});
  factory Graduate.fromJson(Map<String, dynamic> json) =>
      _$GraduateFromJson(json);

  static Graduate fromJsonModel(dynamic json) => Graduate.fromJson(json);
}
