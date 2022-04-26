import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/models/app_file_with_url.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';

class FilePickerWidgetEdit extends StatelessWidget {
  final List<AppFileWithUrl>? pickedFiles;
  final Function(AppFile) onFilesPicked;
  final Function(AppFileWithUrl) onFileRemoved;

  const FilePickerWidgetEdit({
    Key? key,
    this.pickedFiles,
    required this.onFilesPicked,
    required this.onFileRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropTarget(
          onDragDone: pickedFiles!.length >= 2
              ? null
              : (detail) async {
                  final files = detail.files;
                  for (final xfile in files) {
                    if ((xfile.mimeType?.endsWith('/pdf') ?? false) ||
                        (xfile.mimeType?.endsWith('/msword') ?? false) ||
                        (xfile.mimeType?.endsWith(
                                '/vnd.openxmlformats-officedocument.wordprocessingml.document') ??
                            false)) {
                      final file = AppFile(
                          bytes: await xfile.readAsBytes(), name: xfile.name);
                      onFilesPicked(file);
                    }
                  }
                },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
            margin: const EdgeInsets.all(10),
            constraints: const BoxConstraints(maxWidth: 990),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.cloud_upload_outlined, size: 80),
                Center(
                  child: Text(
                    Strings.dropFilesHere,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: AppButton(
                      width: 200,
                      buttonType: ButtonType.secondary,
                      onPressed: pickedFiles!.length >= 2
                          ? null
                          : () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                      allowMultiple: true,
                                      type: FileType.custom,
                                      withData: true,
                                      allowedExtensions: [
                                    'pdf',
                                    'doc',
                                    'docx'
                                  ]);

                              if (result != null) {
                                for (var file in result.files) {
                                  final appfile = AppFile(
                                      bytes: file.bytes!, name: file.name);
                                  onFilesPicked(appfile);
                                }
                              } else {
                                // User canceled the picker
                              }
                            },
                      text: 'تصفح الملفات'),
                )
              ],
            ),
          ),
        ),
        Column(
          children: pickedFiles!
              .map((e) => PickedFileCard(
                    file: e,
                    onDeletePressed: () => onFileRemoved(e),
                  ))
              .toList(),
        )
      ],
    );
  }
}

class PickedFileCard extends StatelessWidget {
  const PickedFileCard(
      {Key? key, required this.file, required this.onDeletePressed})
      : super(key: key);

  final AppFileWithUrl file;
  final VoidCallback onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  file.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                  onPressed: onDeletePressed,
                  icon: const Icon(Icons.delete, color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
