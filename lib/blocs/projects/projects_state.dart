part of 'projects_bloc.dart';

@freezed
class ProjectsState with _$ProjectsState {
  const factory ProjectsState.initial() = _Initial;
  const factory ProjectsState.loading() = _Loading;
  const factory ProjectsState.loaded(ResWithCount<Project> results) = _Loaded;
  const factory ProjectsState.error(AppError error) = _Error;
}
