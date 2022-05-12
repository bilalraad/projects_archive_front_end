import 'package:bloc/bloc.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/helper/res_with_count.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/models/graduate.dart';
import 'package:projects_archiving/utils/enums.dart';

class GraduatesCubit extends Cubit<BlocsState<ResWithCount<Graduate>>> {
  final ProjectsApi _projectsRepo;
  GraduatesCubit(ProjectsApi projectsRepo)
      : _projectsRepo = projectsRepo,
        super(const BlocsState.initial());

  Future<void> graduates(Level? level) async {
    await apiCallsWrapper(_projectsRepo.students(level?.name))
        .listen((event) => emit(event))
        .asFuture();
  }
}
