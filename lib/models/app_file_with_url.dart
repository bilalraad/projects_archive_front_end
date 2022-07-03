import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as p;
import 'package:projects_archiving/utils/enums.dart';

part 'app_file_with_url.g.dart';

@JsonSerializable()
class AppFileWithUrl {
  final int id;
  final String title;
  final String path;

  AppFileWithUrl(this.id, this.title, this.path);

  factory AppFileWithUrl.fromJson(Map<String, dynamic> json) =>
      _$AppFileWithUrlFromJson(json);

  ReportFileType get fileType {
    // final path = '/some/path/to/file/file.dart';
    final extension = p.extension(path); // '.dart'
    if (extension.contains('pdf')) {
      return ReportFileType.pdf;
    } else if (extension.contains('zip')) {
      return ReportFileType.zip;
    } else {
      return ReportFileType.unKnown;
    }
  }

  bool get isTmepFile => path == 'temp';
  static AppFileWithUrl createTempFile(String name) {
    return AppFileWithUrl(Random().nextInt(100), name, 'temp');
  }
}
