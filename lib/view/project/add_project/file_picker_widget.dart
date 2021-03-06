import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/utils/app_utils.dart';
import 'package:projects_archiving/utils/enums.dart';
import 'package:projects_archiving/utils/context_extentions.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';

typedef FilePickerCallback = void Function(AppFile);

class FilePickerWidget extends StatelessWidget {
  final List<AppFile>? pickedFiles;
  final int filesLimit;
  final List<PickerFileTypes> fileTypes;
  final FilePickerCallback onFilesPicked;
  final FilePickerCallback onFileRemoved;

  const FilePickerWidget({
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
                      text: '???????? ??????????????'),
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

  final AppFile file;
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      file.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      getFileSize(file.bytes.length, 2),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
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

Future<void> dragedFileTypeValidation({
  required DropDoneDetails filesDetails,
  required List<PickerFileTypes> selectedTypes,
  required FilePickerCallback onFileValidated,
  required BuildContext context,
}) async {
  final files = filesDetails.files;
  for (var xfile in files) {
    final check =
        //pdf check
        (selectedTypes.contains(PickerFileTypes.pdf) &&
                (xfile.mimeType?.endsWith('/pdf') ?? false)) ||
            //zip check
            (selectedTypes.contains(PickerFileTypes.zip) &&
                (xfile.mimeType?.endsWith('/zip') ?? false)) ||
            //word check
            ((selectedTypes.contains(PickerFileTypes.doc) ||
                    selectedTypes.contains(PickerFileTypes.docx)) &&
                ((xfile.mimeType?.endsWith('/msword') ?? false) ||
                    (xfile.mimeType?.endsWith(
                            '/vnd.openxmlformats-officedocument.wordprocessingml.document') ??
                        false))) ||
            (selectedTypes.contains(PickerFileTypes.xlsx) &&
                (xfile.mimeType?.endsWith(
                        'vnd.openxmlformats-officedocument.spreadsheetml.sheet') ??
                    false));

    if (check) {
      final file = AppFile(bytes: await xfile.readAsBytes(), name: xfile.name);
      onFileValidated(file);
    } else {
      context.showSnackBar('?????????? ?????? ????????????', isError: true);
    }
  }
}
