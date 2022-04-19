import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:projects_archiving/models/app_file_with_url.dart';
import 'package:projects_archiving/utils/enums.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class Project with _$Project {
  factory Project({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'graduation_year') required DateTime graduationYear,
    @JsonKey(name: 'student_name') required String studentName,
    @JsonKey(name: 'student_phone_no') required String? studentPhoneNo,
    @JsonKey(name: 'supervisor_name') required String supervisorName,
    @JsonKey(name: 'abstract') required String? abstract,
    @JsonKey(name: 'files', defaultValue: [])
        required List<AppFileWithUrl> files,
    @JsonKey(name: 'key_words', defaultValue: [])
        required List<String> keywords,
    @JsonKey(name: 'level') required Level level,
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
    @JsonKey(name: 'level') required Level level,
  }) = _ProjectsFilter;

  factory ProjectsFilter.fromJson(Map<String, dynamic> json) =>
      _$ProjectsFilterFromJson(json);
}

@freezed
class AddProject with _$AddProject {
  factory AddProject({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'graduation_year') required DateTime? graduationYear,
    @JsonKey(name: 'student_name') required String studentName,
    @JsonKey(name: 'student_phone_no') required String studentPhoneNo,
    @JsonKey(name: 'supervisor_name') required String supervisorName,
    @JsonKey(name: 'abstract') required String abstract,
    @JsonKey(name: 'key_words', defaultValue: [])
        required List<String> keywords,
    @JsonKey(name: 'level') required Level level,
  }) = _AddProject;

  factory AddProject.fromJson(Map<String, dynamic> json) =>
      _$AddProjectFromJson(json);

  factory AddProject.empty() => AddProject(
      name: '',
      graduationYear: null,
      studentName: '',
      studentPhoneNo: '',
      supervisorName: '',
      abstract: '',
      keywords: [],
      level: Level.bachelor);

  static AddProject fromJsonModel(dynamic json) => AddProject.fromJson(json);
}
