import 'package:bloc/bloc.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/data/shared_pref_helper.dart';

class UserCubit extends Cubit<BlocsState> {
  final ProjectsApi _projectsRepo;
  final SharedPreferenceHelper _prefHelper;

  UserCubit(ProjectsApi projectsRepo, SharedPreferenceHelper prefHelper)
      : _projectsRepo = projectsRepo,
        _prefHelper = prefHelper,
        super(const BlocsState.initial());

  Future<void> logIn({required String email, required String password}) async {
    await apiCallsWrapper<void>(
            _projectsRepo.logIn(email: email, password: password))
        .listen((event) => emit(event))
        .asFuture();
  }

  Future<void> logOut() async {
    await _prefHelper.removeAuthToken();
    await _prefHelper.removeUser();
    emit(const BlocsState.data(null));
  }

  bool get isLoggedIn => _prefHelper.user != null;

  Future<void> createUser(
      {required String email,
      required String password,
      required Role role,
      required String name}) async {
    await apiCallsWrapper<void>(_projectsRepo.createUser(
            email: email, password: password, name: name))
        .listen((event) => emit(event))
        .asFuture();
  }
}

enum Role {
  admin,
  superAdmin,
}
