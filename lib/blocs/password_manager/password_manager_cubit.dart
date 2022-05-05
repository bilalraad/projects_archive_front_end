import 'package:bloc/bloc.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/models/reset_password.dart';

class PasswordManagerCubit extends Cubit<BlocsState<void>> {
  final ProjectsApi _projectsRepo;
  PasswordManagerCubit(ProjectsApi projectsRepo)
      : _projectsRepo = projectsRepo,
        super(const BlocsState.initial());

  Future<void> sendForgotPasswordEmail(String email) async {
    await apiCallsWrapper<void>(_projectsRepo.sendForgotPasswordEmail(email))
        .listen((event) => emit(event))
        .asFuture();
  }

  Future<void> resetPassword({required ResetPassword data}) async {
    await apiCallsWrapper<void>(_projectsRepo.resetPassword(data))
        .listen((event) => emit(event))
        .asFuture();
  }

  void reset() {
    emit(const BlocsState.initial());
  }
}
