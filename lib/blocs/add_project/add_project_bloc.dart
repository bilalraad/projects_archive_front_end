import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/models/project.dart';
import 'package:projects_archiving/utils/enums.dart';

part 'add_project_event.dart';
part 'add_project_state.dart';
part 'add_project_bloc.freezed.dart';

class AddProjectBloc extends Cubit<BlocsState> with ChangeNotifier {
  final ProjectsApi _projectsRepo;
  AddProjectBloc(ProjectsApi projectsRepo)
      : _projectsRepo = projectsRepo,
        super(const BlocsState.initial());

  Future<void> submitProject(AddProject project, List<AppFile> files) async {
    await apiCallsWrapper(
            _projectsRepo.addProject(newProject: project, files: files))
        .listen((event) => emit(event))
        .asFuture();
  }
}
