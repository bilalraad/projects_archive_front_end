import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:projects_archiving/data/api/helper/endpoints.dart';
import 'package:projects_archiving/data/api/helper/map_utils.dart';
import 'package:projects_archiving/models/project.dart';
import 'package:url_launcher/url_launcher.dart';

void downLoadFile(String path) {
  launch(dotenv.env['BASE_URL']! + "/$path");
}

void downLoadExcel(ProjectsFilter filter) {
  var uri = Uri.parse(dotenv.env['BASE_URL']! + Endpoint.projects + "/export");
  uri = uri.replace(queryParameters: filter.toJson().cleanUpValues());

  launch(uri.toString());
}
