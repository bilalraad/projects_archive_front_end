import 'dart:convert';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mime/mime.dart';
import 'package:projects_archiving/blocs/add_project/add_project_bloc.dart';
import 'package:projects_archiving/utils/enums.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/app_text_feild.dart';
import 'package:provider/provider.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  late TextEditingController _projectNameController,
      _strudentNameController,
      _supervisorNameController,
      _studentPhoneNumberController,
      _keyWordController,
      _abstractController;

  late AddProjectBloc _pBloc;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _projectNameController = TextEditingController();
    _strudentNameController = TextEditingController();
    _supervisorNameController = TextEditingController();
    _abstractController = TextEditingController();
    _keyWordController = TextEditingController();
    _studentPhoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _pBloc = Provider.of<AddProjectBloc>(context);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
              key: _formKey,
              child: Scrollbar(
                child: Column(
                  children: [
                    Text(
                      Strings.addProject,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: Colors.black),
                    ),
                    Text(Strings.pleaseFillProjectInfo,
                        style: Theme.of(context).textTheme.headline6),
                    Wrap(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              AppTextField(
                                controller: _projectNameController,
                                lableText: Strings.projectName,
                                onChanged: (v) => _pBloc.add(
                                    AddProjectEvent.updateProject(
                                        _pBloc.state.copyWith(name: v))),
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: _strudentNameController,
                                lableText: Strings.studentName,
                                onChanged: (v) => _pBloc.add(
                                    AddProjectEvent.updateProject(
                                        _pBloc.state.copyWith(studentName: v))),
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: _supervisorNameController,
                                lableText: Strings.supervisorName,
                                onChanged: (v) => _pBloc.add(
                                    AddProjectEvent.updateProject(_pBloc.state
                                        .copyWith(supervisorName: v))),
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: _studentPhoneNumberController,
                                lableText: Strings.studentPhoneNumber,
                                onChanged: (v) => _pBloc.add(
                                    AddProjectEvent.updateProject(_pBloc.state
                                        .copyWith(studentPhoneNo: v))),
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: _abstractController,
                                lableText: Strings.abstract +
                                    Strings.optionalWithBrackets,
                                minLines: 5,
                                onChanged: (v) => _pBloc.add(
                                    AddProjectEvent.updateProject(
                                        _pBloc.state.copyWith(abstract: v))),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                Strings.keywords + Strings.optionalWithBrackets,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: AppTextField(
                                      lableText: 'مثال: تطبيق هاتف',
                                      controller: _keyWordController,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 1,
                                    child: AppButton(
                                        text: 'اضافة',
                                        buttonType: ButtonType.secondary,
                                        onPressed: () {
                                          if (_keyWordController
                                              .text.isNotEmpty) {
                                            var nkw = _pBloc.state.keywords!
                                              ..add(_keyWordController.text);
                                            _pBloc.add(
                                                AddProjectEvent.updateProject(
                                                    _pBloc.state.copyWith(
                                                        keywords: nkw)));
                                          }
                                        }),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              BlocListener<AddProjectBloc, AddProjectState>(
                                listener: (context, state) {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).dividerColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 200,
                                  width: double.infinity,
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    childAspectRatio: 30 / 10,
                                    children: _pBloc.state.keywords!
                                        .map((e) => Container(
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(.4),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(e),
                                                  ),
                                                  const Spacer(),
                                                  IconButton(
                                                      onPressed: () {
                                                        if (_keyWordController
                                                            .text.isNotEmpty) {
                                                          var nkw = _pBloc
                                                              .state.keywords!
                                                            ..remove(e);
                                                          _pBloc.add(AddProjectEvent
                                                              .updateProject(_pBloc
                                                                  .state
                                                                  .copyWith(
                                                                      keywords:
                                                                          nkw)));
                                                        }
                                                      },
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      icon: const Icon(
                                                          Icons.delete))
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              BlocBuilder<AddProjectBloc, AddProjectState>(
                                builder: (context, state) {
                                  return SizedBox(
                                    height: 70,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            showDatePicker(
                                                    context: context,
                                                    initialDatePickerMode:
                                                        DatePickerMode.year,
                                                    initialDate:
                                                        state.graduationYear ??
                                                            DateTime.now(),
                                                    firstDate: DateTime(1800),
                                                    lastDate: DateTime.now())
                                                .then((sd) {
                                              if (sd != null) {
                                                _pBloc.add(AddProjectEvent
                                                    .updateProject(
                                                        state.copyWith(
                                                            graduationYear:
                                                                sd)));
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            width: 150,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .dividerColor),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_month_rounded,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                const SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                        Strings.graduationYear),
                                                    Text(
                                                      state.graduationYear?.year
                                                              .toString() ??
                                                          Strings
                                                              .graduationYear,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          ?.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        BlocBuilder<AddProjectBloc,
                                            AddProjectState>(
                                          builder: (context, state) {
                                            return Container(
                                              width: 160,
                                              height: 70,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .dividerColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(Strings.level),
                                                  DropdownButtonFormField<
                                                          Level>(
                                                      isDense: true,
                                                      icon: const SizedBox
                                                          .shrink(),
                                                      decoration:
                                                          const InputDecoration
                                                              .collapsed(
                                                        hintText: '',
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      items: Level.values
                                                          .map((e) =>
                                                              DropdownMenuItem<
                                                                      Level>(
                                                                  child: Text(
                                                                    Strings
                                                                        .translateLevel(
                                                                            e),
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .subtitle1
                                                                        ?.copyWith(
                                                                            color:
                                                                                Theme.of(context).primaryColor),
                                                                  ),
                                                                  value: e))
                                                          .toList(),
                                                      value: state.level,
                                                      onChanged: (lvl) {
                                                        _pBloc.add(AddProjectEvent
                                                            .updateProject(_pBloc
                                                                .state
                                                                .copyWith(
                                                                    level:
                                                                        lvl!)));
                                                      }),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FilePickerWidget(onFilesPicked: (f) async {
                      print(f.path);
                      _pBloc
                          .add(AddProjectEvent.addFile(await f.readAsBytes()));
                    }),
                    BlocBuilder<AddProjectBloc, AddProjectState>(
                      builder: (context, state) {
                        return Column(
                          children: state.files!
                              .map((e) => Text(e.length.toString()))
                              .toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                        width: 300,
                        onPressed: () async {},
                        text: Strings.addProject),
                    const SizedBox(height: 10),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

class FilePickerWidget extends StatelessWidget {
  final List<File>? pickedFiles;
  final Function(File) onFilesPicked;

  const FilePickerWidget(
      {Key? key, this.pickedFiles, required this.onFilesPicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          DropTarget(
            onDragDone: (detail) async {
              final files = detail.files;
              for (final xfile in files) {
                print(xfile.mimeType);
                if ((xfile.mimeType?.endsWith('/pdf') ?? false) ||
                    (xfile.mimeType?.endsWith('/msword') ?? false) ||
                    (xfile.mimeType?.endsWith(
                            '/vnd.openxmlformats-officedocument.wordprocessingml.document') ??
                        false)) {
                  final file = File(xfile.path);
                  onFilesPicked(file);
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload_outlined, size: 80),
                  const Text(
                    'قم بأسقاط الملفات هنا',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                      width: 300,
                      buttonType: ButtonType.secondary,
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                                allowMultiple: true,
                                type: FileType.custom,
                                allowedExtensions: ['pdf', 'doc', 'docx']);

                        if (result != null) {
                          for (var file in result.files) {
                            print('x');
                            print(file.bytes!.length);

                            final encryptedBase64EncodedString =
                                latin1.decode(file.bytes!.toList());
                            print('y');

                            final decoded =
                                base64.decode(encryptedBase64EncodedString);
                            print('z');

                            onFilesPicked(File.fromRawPath(decoded));
                          }
                        } else {
                          // User canceled the picker
                        }
                      },
                      text: 'اختر ملف')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
