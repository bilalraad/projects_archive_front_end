import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/edit_project/edit_project_bloc.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/models/app_file_with_url.dart';
import 'package:projects_archiving/models/project.dart';
import 'package:projects_archiving/utils/enums.dart';
import 'package:projects_archiving/utils/snack_bar.dart';
import 'package:projects_archiving/utils/validation_builder.dart';
import 'package:projects_archiving/view/project/edit_project/file_picker_widget_edit.dart';
import 'package:projects_archiving/view/project/project_details/project_details.dart';
import 'package:projects_archiving/view/widgets/keywords_widget.dart';
import 'package:projects_archiving/view/widgets/level_drop_dropdown.dart';
import 'package:projects_archiving/view/widgets/year_picker.dart';
import 'package:provider/provider.dart';

import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/app_text_feild.dart';

class EditProjectScreen extends StatefulWidget {
  final Project project;
  const EditProjectScreen({Key? key, required this.project}) : super(key: key);

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  late TextEditingController _pNameC,
      _studentNameC,
      _supervisorNameC,
      _studentPhoneNumberC,
      _abstractC;
  late EditProjectBloc _editBloc;
  List<AppFileWithUrl> files = [];
  List<AppFile> filesToBeUploaded = [];
  List<AppFileWithUrl> filesToBeRemoved = [];

  List<String> keyWords = [];
  DateTime? graduationYear;
  Level? level;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _pNameC = TextEditingController(text: widget.project.name);
    _studentNameC = TextEditingController(text: widget.project.studentName);
    _supervisorNameC =
        TextEditingController(text: widget.project.supervisorName);
    _abstractC = TextEditingController(text: widget.project.abstract);
    _studentPhoneNumberC =
        TextEditingController(text: widget.project.studentPhoneNo);
    files.addAll(widget.project.files);
    keyWords.addAll(widget.project.keywords);
    graduationYear = widget.project.graduationYear;
    super.initState();
  }

  @override
  void dispose() {
    _pNameC.dispose();
    _studentNameC.dispose();
    _supervisorNameC.dispose();
    _abstractC.dispose();
    _studentPhoneNumberC.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _editBloc = Provider.of<EditProjectBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const AppBackButton(),
              Expanded(
                child: SingleChildScrollView(
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
                                    constraints:
                                        const BoxConstraints(maxWidth: 500),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        AppTextField(
                                          controller: _pNameC,
                                          lableText: Strings.projectName,
                                          validator: ValidationBuilder()
                                              .maxLength(255)
                                              .required()
                                              .build(),
                                        ),
                                        const SizedBox(height: 10),
                                        AppTextField(
                                          controller: _studentNameC,
                                          lableText: Strings.studentName,
                                          validator: ValidationBuilder()
                                              .maxLength(255)
                                              .required()
                                              .build(),
                                        ),
                                        const SizedBox(height: 10),
                                        AppTextField(
                                          controller: _supervisorNameC,
                                          lableText: Strings.supervisorName,
                                          validator: ValidationBuilder()
                                              .maxLength(255)
                                              .required()
                                              .build(),
                                        ),
                                        const SizedBox(height: 10),
                                        AppTextField(
                                          controller: _studentPhoneNumberC,
                                          // onChanged: (v) => project =
                                          //     project.copyWith(
                                          //         studentPhoneNo:
                                          //             ValidationBuilder()
                                          //                 .a2e(v)),
                                          lableText: Strings.studentPhoneNumber,
                                          validator: ValidationBuilder(
                                                  isOptional: true)
                                              .phone()
                                              .build(),
                                        ),
                                        const SizedBox(height: 10),
                                        AppTextField(
                                          controller: _abstractC,
                                          validator: ValidationBuilder(
                                                  isOptional: true)
                                              .minLength(20)
                                              .build(),
                                          lableText: Strings.abstract +
                                              Strings.optionalWithBrackets,
                                          minLines: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    constraints:
                                        const BoxConstraints(maxWidth: 500),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        Text(
                                          Strings.keywords +
                                              Strings.optionalWithBrackets,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                        const SizedBox(height: 10),
                                        StatefulBuilder(
                                            builder: (context, setState) {
                                          return KeyWordsWidget(
                                            keywords: keyWords,
                                            onKeyWordAdded: (kw) => setState(
                                                () => keyWords.add(kw)),
                                            onkeyWordDeleted: (kw) => setState(
                                                () => keyWords.remove(kw)),
                                          );
                                        }),
                                        const SizedBox(height: 10),
                                        StatefulBuilder(
                                            builder: (context, setState) {
                                          return SizedBox(
                                            height: 70,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AppYearPicker(
                                                  selectedDate: graduationYear,
                                                  onYearSelected: (y) {
                                                    if (y != null) {
                                                      setState(() =>
                                                          graduationYear = y);
                                                    }
                                                  },
                                                ),
                                                const SizedBox(width: 10),
                                                AppLevelDropDown(
                                                  selectedLevel: level,
                                                  onLevelChanged: (lvl) =>
                                                      setState(
                                                          () => level = lvl),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              StatefulBuilder(builder: (context, setState) {
                                return FilePickerWidgetEdit(
                                  pickedFiles: files,
                                  onFileRemoved: (f) => setState(() {
                                    files.remove(f);
                                    if (f.isTmepFile) {
                                      filesToBeUploaded.removeWhere(
                                          (t) => t.name == f.title);
                                    } else {
                                      filesToBeRemoved.add(f);
                                    }
                                  }),
                                  onFilesPicked: (f) {
                                    setState(() {
                                      files.add(AppFileWithUrl.createTempFile(
                                          f.name));
                                      filesToBeUploaded.add(f);
                                    });
                                  },
                                );
                              }),
                              const SizedBox(height: 10),
                              AppButton(
                                  width: 300,
                                  isLoading: _editBloc.state.maybeWhen(
                                      loading: () => true, orElse: () => false),
                                  onPressed: () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    if (files.isEmpty) {
                                      context.showSnackBar(
                                          'الرجاء رفع تقرير المشروع',
                                          isError: true);
                                      return;
                                    }
                                    //TODO: SHOW CONFIRM DIALOG

                                    // Remove files
                                    for (var f in filesToBeRemoved) {
                                      _editBloc.removeFile(f);
                                      _editBloc.state.whenOrNull(failure: (e) {
                                        context.showSnackBar(e.readableMessage,
                                            isError: true);
                                        return;
                                      });
                                    }
                                    // Upload files
                                    if (filesToBeUploaded.isNotEmpty) {
                                      await _editBloc.uploadFiles(
                                          filesToBeUploaded,
                                          widget.project.id.toString());
                                      _editBloc.state.whenOrNull(failure: (e) {
                                        context.showSnackBar(e.readableMessage,
                                            isError: true);
                                        return;
                                      });
                                    }

                                    // Submit Edit
                                    _editBloc.editProject(
                                        EditProject(
                                            name: _pNameC.text,
                                            graduationYear: graduationYear,
                                            studentName: _studentNameC.text,
                                            studentPhoneNo: ValidationBuilder()
                                                .a2e(_studentPhoneNumberC.text),
                                            supervisorName:
                                                _supervisorNameC.text,
                                            abstract: _abstractC.text,
                                            keywords: keyWords,
                                            level: level),
                                        widget.project.id.toString());
                                    _editBloc.state.whenOrNull(data: (_) {
                                      context.showSnackBar(
                                          'تم تعديل المشروع بنجاح');
                                      AutoRouter.of(context)
                                          .replace(const MyHomeRoute());
                                    }, failure: (e) {
                                      context.showSnackBar(e.readableMessage,
                                          isError: true);
                                      return;
                                    });
                                  },
                                  text: Strings.save),
                              const SizedBox(height: 10),
                            ],
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
