import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/models/project.dart';
import 'package:projects_archiving/utils/enums.dart';

part 'add_project_event.dart';
part 'add_project_state.dart';
part 'add_project_bloc.freezed.dart';

class AddProjectBloc extends Bloc<AddProjectEvent, AddProjectState> {
  AddProjectBloc(ProjectsApi _projectsRepo)
      : super(AddProjectState(files: [], keywords: [])) {
    on<_AddFile>((event, emit) {
      emit(state.copyWith(files: state.files!..add(event.file)));
    });
    on<_UpdateProject>((event, emit) {
      emit(event.newState);
    });
    // on<_Submit>((event, emit) {
    //   emit(state.copyWith(project: event.project));
    // });
  }
}
