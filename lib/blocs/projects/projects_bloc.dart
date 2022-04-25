import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:projects_archiving/blocs/projects_filter/projects_filter_bloc.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/helper/res_with_count.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/models/project.dart';
part 'projects_event.dart';
part 'projects_bloc.freezed.dart';

class ProjectsBloc
    extends Bloc<ProjectsEvent, BlocsState<ResWithCount<Project>>> {
  late StreamSubscription filterSubscription;

  ProjectsBloc(ProjectsApi _projectsRepo, ProjectsFilterBloc filterBloc)
      : super(const Initial()) {
    on<_Started>((event, emit) async {
      await apiCallsWrapper<ResWithCount<Project>>(_projectsRepo.getProjects())
          .listen((event) {
        emit(event);
      }).asFuture();
    });
    filterSubscription = filterBloc.stream.listen((state) {
      state.whenOrNull(changed: (filter) {
        add(_LoadProjects(0, filter));
      });
    });
    on<_LoadProjects>((event, emit) async {
      await apiCallsWrapper<ResWithCount<Project>>(
              _projectsRepo.getProjects(filter: event.filter, skip: event.skip))
          .listen((event) {
        emit(event);
      }).asFuture();
    });
  }
  @override
  Future<void> close() {
    filterSubscription.cancel();
    return super.close();
  }
}
