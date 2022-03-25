part of 'add_project_bloc.dart';

@freezed
class AddProjectEvent with _$AddProjectEvent {
  const factory AddProjectEvent.started() = _Started;
  const factory AddProjectEvent.addFile(Uint8List file) = _AddFile;
  const factory AddProjectEvent.updateProject(Project project) = _UpdateProject;
  const factory AddProjectEvent.submit(Project project, List<Uint8List> files) =
      _Submit;
}
