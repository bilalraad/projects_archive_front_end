import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:projects_archiving/models/project.dart';

part 'projects_filter_event.dart';
part 'projects_filter_state.dart';
part 'projects_filter_bloc.freezed.dart';

class ProjectsFilterBloc
    extends Bloc<ProjectsFilterEvent, ProjectsFilterState> {
  ProjectsFilterBloc() : super(_Initial(ProjectsFilter(keywords: []))) {
    on<_Started>((event, emit) {
      emit(_Initial(ProjectsFilter(keywords: [])));
    });
    on<_Update>((event, emit) {
      emit(_Changed(event.newFilter));
    });
  }

  void updateFilter(ProjectsFilter newf) {
    add(_Update(newf));
  }
}
