part of 'projects_filter_bloc.dart';

@freezed
class ProjectsFilterState with _$ProjectsFilterState {
  const factory ProjectsFilterState.initial(ProjectsFilter filter) = _Initial;
  const factory ProjectsFilterState.changed(ProjectsFilter filter) = _Changed;
}
