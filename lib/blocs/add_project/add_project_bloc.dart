import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/models/project.dart';
import 'package:projects_archiving/utils/app_error.dart';
import 'package:projects_archiving/utils/enums.dart';

part 'add_project_event.dart';
part 'add_project_state.dart';
part 'add_project_bloc.freezed.dart';

class AddProjectBloc extends Bloc<AddProjectEvent, ProjectFormState>
    with ChangeNotifier {
  final ProjectsApi _projectsRepo;
  AddProjectBloc(ProjectsApi projectsRepo)
      : _projectsRepo = projectsRepo,
        super(ProjectFormState(files: [], keywords: [])) {
    on<AddProjectEvent>((event, emit) {
      event.whenOrNull(
          addFile: (file) =>
              emit(state.copyWith(files: state.files!..add(file))),
          removeFile: (file) =>
              emit(state.copyWith(files: state.files!..remove(file))),
          updateProject: (newState) => emit(newState),
          submit: () async {});
    });
  }

  BlocsState<void> submitResponse = const BlocsState.initial();

  Future<void> submitProject(ProjectFormState data) async {
    submitResponse = BlocsState.loading();
    await Future.delayed(Duration(seconds: 2));
    submitResponse = BlocsState.failure(AppError(raw: '', stack: ''));

    // await apiCallsWrapper(_projectsRepo.addProject(
    //         newProject: AddProject(
    //           abstract: data.abstract ?? '',
    //           graduationYear: data.graduationYear,
    //           keywords: data.keywords ?? [],
    //           level: data.level!,
    //           name: data.name!,
    //           studentName: data.studentName!,
    //           studentPhoneNo: data.studentPhoneNo ?? "",
    //           supervisorName: data.supervisorName!,
    //         ),
    //         files: data.files!))
    //     .listen((event) => submitResponse = event)
    //     .asFuture();
  }
}
