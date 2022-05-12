import 'package:bloc/bloc.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/helper/res_with_count.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/models/teacher.dart';

class TeachersCubit extends Cubit<BlocsState<ResWithCount<Teacher>>> {
  final ProjectsApi _projectsRepo;
  TeachersCubit(ProjectsApi projectsRepo)
      : _projectsRepo = projectsRepo,
        super(const BlocsState.initial());

  Future<void> teachers() async {
    await apiCallsWrapper(_projectsRepo.teachers())
        .listen((event) => emit(event))
        .asFuture();
  }
}
