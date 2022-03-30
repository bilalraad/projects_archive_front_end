import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:projects_archiving/data/api/dio_client.dart';
import 'package:projects_archiving/data/api/helper/endpoints.dart';
import 'package:projects_archiving/data/api/helper/res_with_count.dart';
import 'package:projects_archiving/data/shared_pref_helper.dart';
import 'package:projects_archiving/models/project.dart';

class ProjectsApi {
  final DioClient _dioClient;
  final SharedPreferenceHelper sharedPreference;

  const ProjectsApi(this._dioClient, this.sharedPreference);

  Future<ResWithCount<Project>> getProjects({
    String? id,
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
      queryParameters.addAll(filter.toJson());
    }
    try {
      var response = await _dioClient.get(Endpoint.projects,
          queryParameters: queryParameters);
      return ResWithCount.fromJson(response.data, Project.fromJsonModel);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProject({
    required AddProject newProject,
    required List<Uint8List> files,
  }) async {
    final formData = FormData.fromMap(newProject.toJson());
    for (var file in files) {
      formData.files.add(MapEntry("images", MultipartFile.fromBytes(file)));
    }
    try {
      var response = await _dioClient.post(Endpoint.projects, data: formData);
    } catch (e) {
      rethrow;
    }
  }
}
