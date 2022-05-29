import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/models/project.dart';

class AddProjectBloc extends Cubit<BlocsState> with ChangeNotifier {
  final ProjectsApi _projectsRepo;
  AddProjectBloc(ProjectsApi projectsRepo)
      : _projectsRepo = projectsRepo,
        super(const BlocsState.initial());

  Future<void> submitProject(AddProject project, List<AppFile> files) async {
    await apiCallsWrapper(
            _projectsRepo.addProject(newProject: project, files: files))
        .listen(emit)
        .asFuture();
  }

  Future<void> projectsUpload(AppFile excelFile) async {
    await apiCallsWrapper(_projectsRepo.projectsUpload(excelFile))
        .listen(emit)
        .asFuture();
  }
}
