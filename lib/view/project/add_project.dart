import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:projects_archiving/blocs/add_project/add_project_bloc.dart';
import 'package:projects_archiving/blocs/projects/projects_bloc.dart';
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

  late DropzoneViewController dropzoneController;
  List<Uint8List> pickedFiles = [];

  DateTime? _selectedYear;
  Level _selectedLevel = Level.bachelor;
  final List<String> _keyWords = [];
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
        child: Container(
          padding: const EdgeInsets.all(8.0),
          constraints: const BoxConstraints(maxWidth: 500),
          alignment: Alignment.center,
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _projectNameController,
                    lableText: Strings.projectName,
                    onChanged: (v) => _pBloc.add(AddProjectEvent.updateProject(
                        _pBloc.state.project.copyWith(name: v))),
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _strudentNameController,
                    lableText: Strings.studentName,
                    onChanged: (v) => _pBloc.add(AddProjectEvent.updateProject(
                        _pBloc.state.project.copyWith(studentName: v))),
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _supervisorNameController,
                    lableText: Strings.supervisorName,
                    onChanged: (v) => _pBloc.add(AddProjectEvent.updateProject(
                        _pBloc.state.project.copyWith(supervisorName: v))),
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _studentPhoneNumberController,
                    lableText: Strings.studentPhoneNumber,
                    onChanged: (v) => _pBloc.add(AddProjectEvent.updateProject(
                        _pBloc.state.project.copyWith(studentPhoneNo: v))),
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<AddProjectBloc, AddProjectState>(
                    builder: (context, state) {
                      return SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                showDatePicker(
                                        context: context,
                                        initialDate:
                                            state.project.graduationYear,
                                        firstDate: DateTime(1800),
                                        lastDate: DateTime.now())
                                    .then((sd) {
                                  if (sd != null) {
                                    state.project.copyWith(graduationYear: sd);
                                  }
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: 150,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).dividerColor),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_rounded,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(Strings.graduationYear),
                                        Text(
                                          state.project.graduationYear.year
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            BlocBuilder<AddProjectBloc, AddProjectState>(
                              builder: (context, state) {
                                return Container(
                                  width: 150,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Theme.of(context).dividerColor),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(Strings.level),
                                      DropdownButtonFormField<Level>(
                                          isDense: true,
                                          icon: const SizedBox.shrink(),
                                          decoration:
                                              const InputDecoration.collapsed(
                                            hintText: '',
                                            border: InputBorder.none,
                                          ),
                                          items: Level.values
                                              .map((e) =>
                                                  DropdownMenuItem<Level>(
                                                      child: Text(
                                                        Strings.translateLevel(
                                                            e),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1
                                                            ?.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                      ),
                                                      value: e))
                                              .toList(),
                                          value: state.project.level,
                                          onChanged: (lvl) {
                                            _pBloc.add(
                                                AddProjectEvent.updateProject(
                                                    _pBloc.state.project
                                                        .copyWith(
                                                            level: lvl!)));
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
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: _abstractController,
                    lableText: Strings.abstract + Strings.optionalWithBrackets,
                    minLines: 5,
                    onChanged: (v) => _pBloc.add(AddProjectEvent.updateProject(
                        _pBloc.state.project.copyWith(abstract: v))),
                  ),
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
                            onPressed: () {
                              if (_keyWordController.text.isNotEmpty) {
                                _pBloc.add(AddProjectEvent.updateProject(
                                    _pBloc.state.project
                                      ..keywords.add(_keyWordController.text)));
                              }
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<AddProjectBloc, AddProjectState>(
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).dividerColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 200,
                        width: double.infinity,
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 30 / 10,
                          children: state.project.keywords
                              .map((e) => Container(
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.4),
                                      border: Border.all(
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(e),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _keyWords.remove(e);
                                              });
                                            },
                                            padding: const EdgeInsets.all(0),
                                            icon: const Icon(Icons.delete))
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        DropzoneView(
                          operation: DragOperation.copy,
                          cursor: CursorType.grab,
                          onCreated: (DropzoneViewController ctrl) =>
                              dropzoneController = ctrl,
                          onLoaded: () => print('Zone loaded'),
                          onError: (String? ev) => print('Error: $ev'),
                          onHover: () => print('Zone hovered'),
                          onDrop: (dynamic ev) async {
                            final bytes =
                                await dropzoneController.getFileData(ev);
                            _pBloc.add(AddProjectEvent.addFile(bytes));
                            // uploadedFile(ev);
                          },
                          onDropMultiple: (ev) {
                            // pickedFiles.addAll(ev)
                            print('Drop multiple: ');
                            print(ev.runtimeType);
                          },
                          onLeave: () => print('Zone left'),
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).dividerColor),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.cloud_upload_outlined,
                                    size: 80),
                                const Text(
                                  'قم بأسقاط الملفات هنا',
                                  style: TextStyle(fontSize: 24),
                                ),
                                const SizedBox(height: 16),
                                AppButton(
                                    width: 300,
                                    onPressed: () async {
                                      final events =
                                          await dropzoneController.pickFiles();
                                      if (events.isEmpty) return;
                                    },
                                    text: 'اختر ملف')
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<AddProjectBloc, AddProjectState>(
                    builder: (context, state) {
                      return Column(
                        children:
                            state.files.map((e) => Text(e.toString())).toList(),
                      );
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future uploadedFile(dynamic event) async {
    final name = event.name;

    final mime = await dropzoneController.getFileMIME(event);
    final byte = await dropzoneController.getFileSize(event);
    final url = await dropzoneController.createFileUrl(event);

    print('Name : $name');
    print('Mime: $mime');

    print('Size : ${byte / (1024 * 1024)}');
    print('URL: $url');

    // setState(() {});
    print(pickedFiles.length);

    // final droppedFile =
    //     FileDataModel(name: name, mime: mime, bytes: byte, url: url);

    // widget.onDroppedFile(droppedFile);
    // setState(() {
    //   highlight = false;
    // });
  }
}
