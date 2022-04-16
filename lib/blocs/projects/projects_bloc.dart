import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/helper/res_with_count.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/models/project.dart';
part 'projects_event.dart';
part 'projects_bloc.freezed.dart';

class ProjectsBloc
    extends Bloc<ProjectsEvent, BlocsState<ResWithCount<Project>>>
    with ChangeNotifier {
  ProjectsBloc(ProjectsApi _projectsRepo) : super(const Initial()) {
    on<_Started>((event, emit) async {
      await apiCallsWrapper<ResWithCount<Project>>(_projectsRepo.getProjects())
          .listen((event) {
        emit(event);
      }).asFuture();
    });
  }
}
