import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  static ProjectsBloc of(BuildContext context, {bool listen = false}) =>
      BlocProvider.of<ProjectsBloc>(context, listen: listen);

  ProjectsBloc(ProjectsApi projectsRepo, ProjectsFilterBloc filterBloc)
      : super(const Initial()) {
    on<_Started>((event, emit) async {
      await apiCallsWrapper<ResWithCount<Project>>(
              projectsRepo.getProjects(filter: filterBloc.state.filter))
          .listen((event) {
        emit(event);
      }).asFuture();
    });

    on<_LoadProjects>((event, emit) async {
      await apiCallsWrapper<ResWithCount<Project>>(projectsRepo.getProjects(
              filter: filterBloc.state.filter, skip: event.skip))
          .listen((event) => emit(event))
          .asFuture();
    });
  }
}
