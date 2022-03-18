import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

enum Level { phD, master, bachelor, unKnown }

@freezed
class Project with _$Project {
  factory Project({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'graduation_year') required DateTime graduationYear,
    @JsonKey(name: 'student_name') required String studentName,
    @JsonKey(name: 'student_phone_no') required String studentPhoneNo,
    @JsonKey(name: 'supervisor_name') required String supervisorName,
    @JsonKey(name: 'abstract') required String abstract,
    @JsonKey(name: 'pdf_url') required String pdfUrl,
    @JsonKey(name: 'doc_url') required String docUrl,
    @JsonKey(name: 'keywords', defaultValue: []) required List<String> keywords,
    @JsonKey(name: 'level', unknownEnumValue: Level.unKnown)
        required Level level,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  static Project fromJsonModel(dynamic json) => Project.fromJson(json);
}

@freezed
class ProjectsFilter with _$ProjectsFilter {
  factory ProjectsFilter({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'graduation_year') required DateTime graduationYear,
    @JsonKey(name: 'student_name') required String studentName,
    @JsonKey(name: 'supervisor_name') required String supervisorName,
    @JsonKey(name: 'abstract') required String abstract,
    @JsonKey(name: 'keywords', defaultValue: []) required List<String> keywords,
    @JsonKey(name: 'level', unknownEnumValue: Level.unKnown)
        required Level level,
  }) = _ProjectsFilter;

  factory ProjectsFilter.fromJson(Map<String, dynamic> json) =>
      _$ProjectsFilterFromJson(json);
}
