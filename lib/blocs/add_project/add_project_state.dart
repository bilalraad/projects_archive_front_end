part of 'add_project_bloc.dart';

class AddProjectState {
  final String? name;
  final DateTime? graduationYear;
  final String? studentName;
  final String? studentPhoneNo;
  final String? supervisorName;
  final String? abstract;
  final List<String>? keywords;
  final Level? level;
  final List<Uint8List>? files;
  AddProjectState({
    this.name,
    this.graduationYear,
    this.studentName,
    this.studentPhoneNo,
    this.supervisorName,
    this.abstract,
    this.keywords,
    this.level = Level.bachelor,
    this.files,
  });

  AddProjectState copyWith({
    String? name,
    DateTime? graduationYear,
    String? studentName,
    String? studentPhoneNo,
    String? supervisorName,
    String? abstract,
    List<String>? keywords,
    Level? level,
    List<Uint8List>? files,
  }) {
    return AddProjectState(
      name: name ?? this.name,
      graduationYear: graduationYear ?? this.graduationYear,
      studentName: studentName ?? this.studentName,
      studentPhoneNo: studentPhoneNo ?? this.studentPhoneNo,
      supervisorName: supervisorName ?? this.supervisorName,
      abstract: abstract ?? this.abstract,
      keywords: keywords ?? this.keywords,
      level: level ?? this.level,
      files: files ?? this.files,
    );
  }
}
