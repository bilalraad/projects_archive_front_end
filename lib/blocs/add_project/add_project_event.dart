part of 'add_project_bloc.dart';

@freezed
class AddProjectEvent with _$AddProjectEvent {
  const factory AddProjectEvent.started() = _Started;
  const factory AddProjectEvent.submit(
      AddProject project, List<AppFile> files) = _Submit;
}
