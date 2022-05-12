import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/states/result_state.dart';
import 'package:projects_archiving/blocs/teachers_and_students/graduates_cubit.dart';
import 'package:projects_archiving/blocs/teachers_and_students/teachers_cubit.dart';
import 'package:projects_archiving/data/api/helper/res_with_count.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/models/graduate.dart';
import 'package:projects_archiving/models/project.dart';
import 'package:projects_archiving/models/teacher.dart';
import 'package:projects_archiving/utils/context_extentions.dart';
import 'package:projects_archiving/utils/validation_builder.dart';
import 'package:projects_archiving/view/project/add_project/file_picker_widget.dart';
import 'package:projects_archiving/view/project/project_details/project_details.dart';
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
  List<AppFile> files = [];

  final _formKey = GlobalKey<FormState>();
  final _sNameDropdownKey = GlobalKey<FormFieldState>();

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
    BlocProvider.of<GraduatesCubit>(context).graduates(project.level);

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
                                          controller: _projectNameController,
                                          lableText: Strings.projectName,
                                          onChanged: (v) => project =
                                              project.copyWith(name: v),
                                          validator: ValidationBuilder()
                                              .maxLength(255)
                                              .required()
                                              .build(),
                                        ),
                                        const SizedBox(height: 10),
                                        BlocBuilder<GraduatesCubit,
                                            BlocsState<ResWithCount<Graduate>>>(
                                          builder: (context, state) {
                                            return AppDropDownFormFeild<String>(
                                              key: _sNameDropdownKey,
                                              items: state.whenOrNull<
                                                  List<
                                                      DropdownMenuItem<
                                                          String>>?>(
                                                data: (gs) => List.generate(
                                                    gs.results.length, (i) {
                                                  return DropdownMenuItem<
                                                          String>(
                                                      value: gs.results[i].name,
                                                      child: Text(
                                                          gs.results[i].name));
                                                }),
                                              ),
                                              value: returnNullIfEmpty(
                                                  project.studentName),
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
                                                  project.copyWith(
                                                      studentName: v!),
                                              lableText: 'اسم الطالب',
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        BlocBuilder<TeachersCubit,
                                            BlocsState<ResWithCount<Teacher>>>(
                                          builder: (context, state) {
                                            return AppDropDownFormFeild<String>(
                                              items: state.whenOrNull<
                                                  List<
                                                      DropdownMenuItem<
                                                          String>>?>(
                                                data: (ts) => ts.results
                                                    .map((e) =>
                                                        DropdownMenuItem<
                                                                String>(
                                                            value: e.name,
                                                            child:
                                                                Text(e.name)))
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
                                                  project.copyWith(
                                                      supervisorName: v!),
                                              lableText: 'اسم المدس',
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        AppTextField(
                                          controller:
                                              _studentPhoneNumberController,
                                          onChanged: (v) => project =
                                              project.copyWith(
                                                  studentPhoneNo:
                                                      ValidationBuilder()
                                                          .a2e(v)),
                                          lableText: Strings.studentPhoneNumber,
                                          validator: ValidationBuilder(
                                                  isOptional: true)
                                              .phone()
                                              .build(),
                                        ),
                                        const SizedBox(height: 10),
                                        AppTextField(
                                          controller: _abstractController,
                                          onChanged: (v) => project =
                                              project.copyWith(abstract: v),
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
                                            keywords: project.keywords,
                                            onKeyWordAdded: (kw) => setState(
                                                () => project.keywords.add(kw)),
                                            onkeyWordDeleted: (kw) => setState(
                                                () => project.keywords
                                                    .remove(kw)),
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
                                                  selectedDate:
                                                      project.graduationYear,
                                                  onYearSelected: (y) {
                                                    if (y != null) {
                                                      setState(() => project =
                                                          project.copyWith(
                                                              graduationYear:
                                                                  y));
                                                    }
                                                  },
                                                ),
                                                const SizedBox(width: 10),
                                                AppLevelDropDown(
                                                  selectedLevel: project.level,
                                                  onLevelChanged: (lvl) {
                                                    project = project.copyWith(
                                                        level: lvl!,
                                                        studentName: '');
                                                    _sNameDropdownKey
                                                        .currentState
                                                        ?.reset();
                                                    BlocProvider.of<
                                                                GraduatesCubit>(
                                                            context)
                                                        .graduates(lvl);

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
                              StatefulBuilder(builder: (context, setState) {
                                return FilePickerWidget(
                                  pickedFiles: files,
                                  onFileRemoved: (f) =>
                                      setState(() => files.remove(f)),
                                  onFilesPicked: (f) =>
                                      setState(() => files.add(f)),
                                );
                              }),
                              const SizedBox(height: 10),
                              AppButton(
                                  width: 300,
                                  isLoading: _pBloc.state.maybeWhen(
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
                                    if (project.graduationYear == null) {
                                      context.showSnackBar(
                                          'الرجاء اختيار سنة التخرج',
                                          isError: true);
                                      return;
                                    }
                                    await _pBloc.submitProject(project, files);
                                    _pBloc.state.whenOrNull(data: (results) {
                                      context
                                          .showSnackBar('تم رفع المشروع بنجاح');
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
            ],
          ),
        ),
      ),
    );
  }
}

String? returnNullIfEmpty(String? value) {
  if (value == null || value.isEmpty) return null;
  return value;
}
