import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/models/app_file_with_url.dart';
import 'package:projects_archiving/utils/enums.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/project/add_project/file_picker_widget.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';

class FilePickerWidgetEdit extends StatelessWidget {
  final List<AppFileWithUrl>? pickedFiles;
  final Function(AppFile) onFilesPicked;
  final Function(AppFileWithUrl) onFileRemoved;

  final int filesLimit;
  final List<PickerFileTypes> fileTypes;

  const FilePickerWidgetEdit({
    Key? key,
    this.pickedFiles,
    required this.onFilesPicked,
    required this.onFileRemoved,
    this.fileTypes = const [
      PickerFileTypes.doc,
      PickerFileTypes.docx,
      PickerFileTypes.pdf
    ],
    this.filesLimit = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String getFileTypesNames() {
      String s = '\n';
      for (var i = 0; i < fileTypes.length; i++) {
        if (i < fileTypes.length - 1) {
          s += "${fileTypes[i].name}, ";
        } else {
          s += fileTypes[i].name;
        }
      }
      return s;
    }

    return Column(
      children: [
        DropTarget(
          onDragDone: pickedFiles!.length >= filesLimit
              ? null
              : (detail) async {
                  await dragedFileTypeValidation(
                      filesDetails: detail,
                      selectedTypes: fileTypes,
                      onFileValidated: onFilesPicked,
                      context: context);
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
                    Strings.dropFilesHere + getFileTypesNames(),
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: AppButton(
                      width: 200,
                      buttonType: ButtonType.secondary,
                      onPressed: pickedFiles!.length >= filesLimit
                          ? null
                          : () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                      allowMultiple: true,
                                      type: FileType.custom,
                                      withData: true,
                                      allowedExtensions: fileTypes
                                          .map((e) => e.name)
                                          .toList());

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
                      text: Strings.browseFiles),
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
