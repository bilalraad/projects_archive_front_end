import 'package:bloc/bloc.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/models/project.dart';

class ProjectDetailsBloc extends Cubit<BlocsState<Project>> {
  final ProjectsApi _projectsRepo;
  ProjectDetailsBloc(ProjectsApi projectsRepo)
      : _projectsRepo = projectsRepo,
        super(const BlocsState.initial());

  Future<void> getProject(int id) async {
    await apiCallsWrapper<Project>(_projectsRepo.getProject(projectId: id))
        .listen((event) => emit(event))
        .asFuture();
  }

  void dispose() {
    emit(const BlocsState.initial());
  }
}
