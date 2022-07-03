import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/blocs/teachers_and_students/teachers_cubit.dart';
import 'package:projects_archiving/data/api/helper/res_with_count.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/models/project.dart';
import 'package:projects_archiving/models/teacher.dart';
import 'package:projects_archiving/utils/app_utils.dart';
import 'package:projects_archiving/utils/context_extentions.dart';
import 'package:projects_archiving/utils/enums.dart';
import 'package:projects_archiving/utils/validation_builder.dart';
import 'package:projects_archiving/view/project/add_project/file_picker_widget.dart';
import 'package:projects_archiving/view/widgets/app_header.dart';
import 'package:projects_archiving/view/widgets/keywords_widget.dart';
import 'package:projects_archiving/view/widgets/level_drop_dropdown.dart';
import 'package:projects_archiving/view/widgets/year_picker.dart';

import 'package:projects_archiving/blocs/add_project/add_project_bloc.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/app_text_feild.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  late TextEditingController _projectNameController,
      _studentNameController,
      _supervisorNameController,
      _studentPhoneNumberController,
      _abstractController;

  late AddProjectBloc _pBloc;

  AddProject project = AddProject.empty();
  AppFile? _reportFile;
  AppFile? _sourceCodeFile;
  List<String> keyWords = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _projectNameController = TextEditingController();
    _studentNameController = TextEditingController();
    _supervisorNameController = TextEditingController();
    _abstractController = TextEditingController();
    _studentPhoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _studentNameController.dispose();
    _supervisorNameController.dispose();
    _abstractController.dispose();
    _studentPhoneNumberController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _pBloc = BlocProvider.of<AddProjectBloc>(context);
    BlocProvider.of<TeachersCubit>(context).teachers();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppHeader(
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
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                AppTextField(
                                  controller: _projectNameController,
                                  lableText: Strings.projectName,
                                  onChanged: (v) =>
                                      project = project.copyWith(name: v),
                                  validator: ValidationBuilder()
                                      .maxLength(255)
                                      .required()
                                      .build(),
                                ),
                                const SizedBox(height: 10),
                                AppTextField(
                                  controller: _studentNameController,
                                  lableText: Strings.studentName,
                                  onChanged: (v) => project =
                                      project.copyWith(studentName: v),
                                  validator: ValidationBuilder()
                                      .maxLength(255)
                                      .required()
                                      .build(),
                                ),
                                const SizedBox(height: 10),
                                BlocBuilder<TeachersCubit,
                                    BlocsState<ResWithCount<Teacher>>>(
                                  builder: (context, state) {
                                    return AppDropDownFormFeild<String>(
                                      items: state.whenOrNull<
                                          List<DropdownMenuItem<String>>?>(
                                        data: (ts) => ts.results
                                            .map((e) =>
                                                DropdownMenuItem<String>(
                                                    value: e.name,
                                                    child: Text(e.name)))
                                            .toList(),
                                      ),
                                      value: returnNullIfEmpty(
                                          project.supervisorName),
                                      validator: ValidationBuilder()
                                          .maxLength(255)
                                          .required()
                                          .build(),
                                      dropIcon: state.whenOrNull(
                                        loading: () =>
                                            const CircularProgressIndicator
                                                .adaptive(),
                                      ),
                                      onChanged: (v) => project =
                                          project.copyWith(supervisorName: v!),
                                      lableText: Strings.supervisorName,
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                AppTextField(
                                  controller: _studentPhoneNumberController,
                                  onChanged: (v) => project = project.copyWith(
                                      studentPhoneNo:
                                          ValidationBuilder().a2e(v)),
                                  lableText: Strings.studentPhoneNumber +
                                      Strings.optionalWithBrackets,
                                  validator: ValidationBuilder(isOptional: true)
                                      .phone()
                                      .build(),
                                ),
                                const SizedBox(height: 10),
                                AppTextField(
                                  controller: _abstractController,
                                  onChanged: (v) =>
                                      project = project.copyWith(abstract: v),
                                  validator: ValidationBuilder(isOptional: true)
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
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  Strings.keywords +
                                      Strings.optionalWithBrackets,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                const SizedBox(height: 10),
                                StatefulBuilder(builder: (context, setState) {
                                  return KeyWordsWidget(
                                    keywords: keyWords,
                                    onKeyWordAdded: (kw) =>
                                        setState(() => keyWords.add(kw)),
                                    onkeyWordDeleted: (kw) =>
                                        setState(() => keyWords.remove(kw)),
                                  );
                                }),
                                const SizedBox(height: 10),
                                StatefulBuilder(builder: (context, setState) {
                                  return SizedBox(
                                    height: 70,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppYearPicker(
                                          selectedDate: project.graduationYear,
                                          onYearSelected: (y) {
                                            if (y != null) {
                                              setState(() => project = project
                                                  .copyWith(graduationYear: y));
                                            }
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        AppLevelDropDown(
                                          selectedLevel: project.level,
                                          onLevelChanged: (lvl) {
                                            project =
                                                project.copyWith(level: lvl!);

                                            setState(() {});
                                          },
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
                      Wrap(
                        children: [
                          SizedBox(
                            width: 500,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Strings.finalReport,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                StatefulBuilder(builder: (context, setState) {
                                  return FilePickerWidget(
                                    pickedFiles: _reportFile != null
                                        ? [_reportFile!]
                                        : [],
                                    filesLimit: 1,
                                    fileTypes: const [PickerFileTypes.pdf],
                                    onFileRemoved: (f) =>
                                        setState(() => _reportFile = null),
                                    onFilesPicked: (f) {
                                      setState(() => _reportFile = f);
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 500,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "الكود الخاص بالمشروع${Strings.optionalWithBrackets}",
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                StatefulBuilder(builder: (context, setState) {
                                  return FilePickerWidget(
                                    pickedFiles: _sourceCodeFile != null
                                        ? [_sourceCodeFile!]
                                        : [],
                                    filesLimit: 1,
                                    fileTypes: const [PickerFileTypes.zip],
                                    onFileRemoved: (f) =>
                                        setState(() => _sourceCodeFile = null),
                                    onFilesPicked: (f) =>
                                        setState(() => _sourceCodeFile = f),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                          width: 300,
                          isLoading: _pBloc.state.maybeWhen(
                              loading: () => true, orElse: () => false),
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            if (_reportFile == null) {
                              context.showSnackBar(Strings.pleaseUploadReport,
                                  isError: true);
                              return;
                            }
                            if (_sourceCodeFile != null &&
                                getFileSizeInMb(_sourceCodeFile!) > 10) {
                              context.showSnackBar(
                                  Strings.sizeMustBeLessThan10Mb,
                                  isError: true);
                              return;
                            }
                            if (project.graduationYear == null) {
                              context.showSnackBar(Strings.pleaseSelectYear,
                                  isError: true);
                              return;
                            }
                            project = project.copyWith(keywords: keyWords);

                            List<AppFile> files = [_reportFile!];
                            if (_sourceCodeFile != null) {
                              files.add(_sourceCodeFile!);
                            }
                            await _pBloc.submitProject(project, files);
                            _pBloc.state.whenOrNull(data: (results) {
                              context
                                  .showSnackBar(Strings.projectUploadSuccess);
                              AutoRouter.of(context)
                                  .replace(const MyHomeRoute());
                            }, failure: (e) {
                              context.showSnackBar(e.readableMessage,
                                  isError: true);
                              return;
                            });
                          },
                          text: Strings.addProject),
                      const SizedBox(height: 10),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
