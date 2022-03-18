import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:projects_archiving/data/api/helper/res_with_count.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/models/project.dart';
import 'package:projects_archiving/utils/app_error.dart';

part 'projects_event.dart';
part 'projects_state.dart';
part 'projects_bloc.freezed.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc(ProjectsApi _projectsRepo) : super(const _Initial()) {
    on<_Started>((event, emit) async {
      emit(const _Loading());
      try {
        var response = await _projectsRepo.getProjects();
        emit(_Loaded(response));
      } catch (e) {
        emit(_Error(AppError(raw: e)));
      }
    });
  }
}
