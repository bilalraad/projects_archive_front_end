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

  FileType get fileType {
    // final path = '/some/path/to/file/file.dart';
    final extension = p.extension(path); // '.dart'
    if (extension.contains('pdf')) {
      return FileType.pdf;
    } else if (extension.contains('doc') || extension.contains('docx')) {
      return FileType.word;
    } else {
      return FileType.unKnown;
    }
  }
}
