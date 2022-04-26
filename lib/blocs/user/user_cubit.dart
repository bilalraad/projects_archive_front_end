import 'package:bloc/bloc.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/projects_api.dart';

class UserCubit extends Cubit<BlocsState> {
  final ProjectsApi _projectsRepo;

  UserCubit(ProjectsApi projectsRepo)
      : _projectsRepo = projectsRepo,
        super(const BlocsState.initial());

  Future<void> logIn({required String email, required String password}) async {
    await apiCallsWrapper<void>(
            _projectsRepo.logIn(email: email, password: password))
        .listen((event) => emit(event))
        .asFuture();
  }

  //TODO: ADD ROLE LATER
  Future<void> createUser(
      {required String email,
      required String password,
      required String name}) async {
    await apiCallsWrapper<void>(_projectsRepo.createUser(
            email: email, password: password, name: name))
        .listen((event) => emit(event))
        .asFuture();
  }
}
