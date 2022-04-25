part of 'projects_filter_bloc.dart';

@freezed
class ProjectsFilterEvent with _$ProjectsFilterEvent {
  const factory ProjectsFilterEvent.started() = _Started;
  const factory ProjectsFilterEvent.update(ProjectsFilter newFilter) = _Update;
}
