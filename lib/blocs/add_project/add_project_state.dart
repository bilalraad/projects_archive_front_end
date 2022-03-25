part of 'add_project_bloc.dart';

@freezed
class AddProjectState with _$AddProjectState {
  factory AddProjectState({
    required Project project,
    required List<Uint8List> files,
  }) = _AddProjectState;
}
