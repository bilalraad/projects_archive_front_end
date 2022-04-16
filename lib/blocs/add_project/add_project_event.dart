part of 'add_project_bloc.dart';

@freezed
class AddProjectEvent with _$AddProjectEvent {
  const factory AddProjectEvent.started() = _Started;
  const factory AddProjectEvent.addFile(AppFile file) = _AddFile;
  const factory AddProjectEvent.removeFile(AppFile file) = _RemoveFile;
  const factory AddProjectEvent.updateProject(ProjectFormState newState) =
      _UpdateProject;
  const factory AddProjectEvent.submit() = _Submit;
}
