import 'package:json_annotation/json_annotation.dart';

part 'teacher.g.dart';

@JsonSerializable()
class Teacher {
  @JsonKey(name: 'name_ar')
  final String name;
  @JsonKey(name: 'id')
  final int id;
  Teacher({required this.name, required this.id});
  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);

  static Teacher fromJsonModel(dynamic json) => Teacher.fromJson(json);
}
