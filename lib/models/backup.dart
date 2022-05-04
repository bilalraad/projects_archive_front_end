import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup.freezed.dart';
part 'backup.g.dart';

@freezed
class Backup {
  factory Backup({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'key') required String key,
    @JsonKey(name: 'size') required String size,
    @JsonKey(name: 'date') required DateTime date,
  }) = _Backup;

  factory Backup.fromJson(Map<String, dynamic> json) => _$BackupFromJson(json);
  static Backup fromJsonModel(dynamic json) => Backup.fromJson(json);
}
