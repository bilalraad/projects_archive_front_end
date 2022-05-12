import 'package:dio/dio.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/dio_client.dart';
import 'package:projects_archiving/data/api/helper/endpoints.dart';
import 'package:projects_archiving/data/api/helper/map_utils.dart';
import 'package:projects_archiving/data/api/helper/res_with_count.dart';
import 'package:projects_archiving/data/api/helper/token.dart';
import 'package:projects_archiving/data/shared_pref_helper.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/models/app_file_with_url.dart';
import 'package:projects_archiving/models/backup.dart';
import 'package:projects_archiving/models/project.dart';
import 'package:projects_archiving/models/reset_password.dart';
import 'package:projects_archiving/models/graduate.dart';
import 'package:projects_archiving/models/teacher.dart';
import 'package:projects_archiving/models/user.dart';
import 'package:projects_archiving/utils/app_error.dart';

Stream<BlocsState<T>> apiCallsWrapper<T>(Future<T> action) async* {
  yield const BlocsState.loading();
  try {
    final data = await action;
    yield BlocsState.data(data);
  } catch (e, s) {
    yield BlocsState.failure(AppError(raw: e, stack: s));
  }
}

class ProjectsApi {
  final DioClient _dioClient;
  final SharedPreferenceHelper sharedPreference;

  const ProjectsApi(this._dioClient, this.sharedPreference);

  Future logIn({required String email, required String password}) async {
    final response = await _dioClient
        .post(Endpoint.logIn, data: {"email": email, "password": password});

    await sharedPreference
        .saveAuthToken(Token(access: response.data['access_token']));
    await sharedPreference.saveUser(User.fromJson(response.data['user']));
  }

  Future<void> createUser(
      {required String email,
      required String password,
      required String role,
      required String name}) async {
    await _dioClient.post(Endpoint.createUser, data: {
      "email": email,
      "password": password,
      "name": name,
      "role": role,
    });
  }

  Future<ResWithCount<Project>> getProjects({
    int? skip,
    int? limit = 25,
    ProjectsFilter? filter,
  }) async {
    Map<String, dynamic> queryParameters = {
      Endpoint.skip: skip,
      Endpoint.limit: limit,
    };
    if (filter != null) {
      queryParameters.addAll(filter.toJson().cleanUpValues());
    }

    var response = await _dioClient.get(Endpoint.projects,
        queryParameters: queryParameters);
    return ResWithCount.fromJson(response.data, Project.fromJsonModel);
  }

  Future uploadFiles(List<AppFile> files, String projectId) async {
    List<MultipartFile> multipartArray = [];

    for (var f in files) {
      multipartArray.add(MultipartFile.fromBytes(f.bytes, filename: f.name));
    }
    final formData = FormData.fromMap({
      'project_id': projectId,
      "files": multipartArray,
    }, ListFormat.multiCompatible);
    await _dioClient.post('/files', data: formData);
  }

  Future projectsUpload(AppFile excelFile) async {
    final formData = FormData.fromMap({
      "file":
          MultipartFile.fromBytes(excelFile.bytes, filename: excelFile.name),
    });
    await _dioClient.post(Endpoint.importProjects, data: formData);
  }

  Future<void> removeFile(AppFileWithUrl file) async {
    await _dioClient.delete('/${file.path}');
  }

  Future<void> addProject({
    required AddProject newProject,
    required List<AppFile> files,
  }) async {
    final response = await _dioClient.post(Endpoint.projects,
        data: newProject.toJson().cleanUpValues());
    await uploadFiles(files, response.data['id'].toString());
  }

  Future<void> editProject(
      {required EditProject project, required String projectId}) async {
    await _dioClient.put(Endpoint.project + projectId,
        data: project.toJson().cleanUpValues());
  }

  Future<Project?> getProject({
    required int projectId,
  }) async {
    final response =
        await _dioClient.get(Endpoint.project + projectId.toString());
    return Project.fromJson(response.data);
  }

  Future<Project?> deleteProject({required int projectId}) async {
    await _dioClient.delete(Endpoint.project + projectId.toString());
    return null;
  }

//Backups section
  Future<T?> createBackup<T>({required String? name}) async {
    await _dioClient.post(Endpoint.backup,
        data: {"name": name}.cleanUpValues());
    return null;
  }

  Future<ResWithCount<Backup>> getAllBackups() async {
    final response = await _dioClient.get(Endpoint.backup);
    return ResWithCount.fromJson(response.data, Backup.fromJsonModel);
  }

  Future<T?> restorBackupWithFile<T>(AppFile zipFile) async {
    final formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(zipFile.bytes, filename: zipFile.name),
    });
    await _dioClient.post(Endpoint.restore, data: formData);
    return null;
  }

  Future<T?> restorBackupWithKey<T>(String key) async {
    await _dioClient.post(Endpoint.restore, data: {'key': key});
    return null;
  }

  Future<T?> deleteBackup<T>(String key) async {
    await _dioClient.delete(Endpoint.destroyBackup, data: {'key': key});
    return null;
  }

  Future sendForgotPasswordEmail(String email) async {
    await _dioClient.post(Endpoint.forgotPassword, data: {'email': email});
    return null;
  }

  Future resetPassword(ResetPassword data) async {
    await _dioClient.post(Endpoint.resetPassword, data: data.toJson());
    return null;
  }

  // teachers and studnets
  Future<ResWithCount<Teacher>> teachers() async {
    final response = await _dioClient.get(Endpoint.teachers);
    return ResWithCount.fromJson(response.data, Teacher.fromJsonModel);
  }

  Future<ResWithCount<Graduate>> students(String? level) async {
    final response = await _dioClient
        .get(Endpoint.graduates, queryParameters: {'level': level});
    return ResWithCount.fromJson(response.data, Graduate.fromJsonModel);
  }
}
