import 'package:bloc/bloc.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/models/app_file_with_url.dart';
import 'package:projects_archiving/models/project.dart';

class EditProjectBloc extends Cubit<BlocsState<void>> {
  final ProjectsApi _projectsRepo;
  EditProjectBloc(ProjectsApi projectsRepo)
      : _projectsRepo = projectsRepo,
        super(const BlocsState.initial());

  Future<void> editProject(EditProject project, String projectId) async {
    await apiCallsWrapper(
            _projectsRepo.editProject(project: project, projectId: projectId))
        .listen((event) => emit(event))
        .asFuture();
  }

  Future<void> uploadFiles(List<AppFile> files, String projectId) async {
    await apiCallsWrapper(_projectsRepo.uploadFiles(files, projectId))
        .listen((event) => emit(event))
        .asFuture();
  }

  Future<void> removeFile(AppFileWithUrl file) async {
    await apiCallsWrapper(_projectsRepo.removeFile(file))
        .listen((event) => emit(event))
        .asFuture();
  }
}
