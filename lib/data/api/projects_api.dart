import 'package:dio/dio.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/data/api/dio_client.dart';
import 'package:projects_archiving/data/api/helper/endpoints.dart';
import 'package:projects_archiving/data/api/helper/map_utils.dart';
import 'package:projects_archiving/data/api/helper/res_with_count.dart';
import 'package:projects_archiving/data/shared_pref_helper.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/models/app_file_with_url.dart';
import 'package:projects_archiving/models/project.dart';
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

  Future<ResWithCount<Project>> getProjects({
    int? skip,
    int? limit = 25,
    String? searchQuery,
    ProjectsFilter? filter,
  }) async {
    Map<String, dynamic> queryParameters = {
      Endpoint.skip: skip,
      Endpoint.limit: limit,
      Endpoint.query: searchQuery,
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

  Future<void> removeFile(AppFileWithUrl file) async {
    await _dioClient.delete('/' + file.path);
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
}
