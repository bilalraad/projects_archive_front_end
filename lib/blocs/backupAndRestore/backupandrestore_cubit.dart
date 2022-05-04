// ignore_for_file: prefer_void_to_null

import 'package:bloc/bloc.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/helper/res_with_count.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/models/backup.dart';

class BackupandrestoreCubit extends Cubit<BlocsState<ResWithCount<Backup>?>> {
  final ProjectsApi _projectsRepo;
  BackupandrestoreCubit(ProjectsApi projectsRepo)
      : _projectsRepo = projectsRepo,
        super(const BlocsState.initial());

  Future<void> creatBackup(String name) async {
    await apiCallsWrapper<Null>(_projectsRepo.createBackup(name: name))
        .listen((event) => emit(event))
        .asFuture();
  }

  Future<void> getAllBackups(String name) async {
    await apiCallsWrapper(_projectsRepo.getAllBackups())
        .listen((event) => emit(event))
        .asFuture();
  }

  Future<void> deleteBackup(String key) async {
    await apiCallsWrapper<Null>(_projectsRepo.deleteBackup(key))
        .listen((event) => emit(event))
        .asFuture();
  }

  Future<void> restoreBackupWithKey(String key) async {
    await apiCallsWrapper<Null>(_projectsRepo.restorBackupWithKey(key))
        .listen((event) => emit(event))
        .asFuture();
  }

  Future<void> restoreBackupWithFile(AppFile file) async {
    await apiCallsWrapper<Null>(_projectsRepo.restorBackupWithFile(file))
        .listen((event) => emit(event))
        .asFuture();
  }
}
