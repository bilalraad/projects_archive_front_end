import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/models/project.dart';
import 'package:projects_archiving/utils/enums.dart';

part 'add_project_event.dart';
part 'add_project_state.dart';
part 'add_project_bloc.freezed.dart';

class AddProjectBloc extends Bloc<AddProjectEvent, AddProjectState> {
  final ProjectsApi _projectsRepo;
  AddProjectBloc(ProjectsApi projectsRepo)
      : _projectsRepo = projectsRepo,
        super(AddProjectState(files: [], keywords: [])) {
    on<_AddFile>((event, emit) {
      emit(state.copyWith(files: state.files!..add(event.file)));
    });
    on<_UpdateProject>((event, emit) {
      emit(event.newState);
    });
  }

  Future<void> submitProject(AddProjectState data) async {
    _projectsRepo.addProject(
        newProject: AddProject(
          abstract: data.abstract ?? '',
          graduationYear: data.graduationYear ?? DateTime.now(),
          keywords: data.keywords ?? [],
          level: data.level ?? Level.bachelor,
          name: data.name ?? '',
          studentName: data.studentName ?? '',
          studentPhoneNo: data.studentPhoneNo ?? "",
          supervisorName: data.supervisorName ?? '',
        ),
        files: data.files!);
  }
}
