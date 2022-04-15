import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/utils/snack_bar.dart';
import 'package:projects_archiving/utils/validation_builder.dart';
import 'package:projects_archiving/view/project/add_project/file_picker_widget.dart';
import 'package:projects_archiving/view/widgets/keywords_widget.dart';
import 'package:projects_archiving/view/widgets/level_drop_dropdown.dart';
import 'package:projects_archiving/view/widgets/year_picker.dart';
import 'package:provider/provider.dart';

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
      _strudentNameController,
      _supervisorNameController,
      _studentPhoneNumberController,
      _abstractController;

  late AddProjectBloc _pBloc;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _projectNameController = TextEditingController();
    _strudentNameController = TextEditingController();
    _supervisorNameController = TextEditingController();
    _abstractController = TextEditingController();
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
                                validator: ValidationBuilder()
                                    .maxLength(255)
                                    .required()
                                    .build(),
                                onChanged: (v) => _pBloc.add(
                                    AddProjectEvent.updateProject(
                                        _pBloc.state.copyWith(name: v))),
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: _strudentNameController,
                                lableText: Strings.studentName,
                                validator: ValidationBuilder()
                                    .maxLength(255)
                                    .required()
                                    .build(),
                                onChanged: (v) => _pBloc.add(
                                    AddProjectEvent.updateProject(
                                        _pBloc.state.copyWith(studentName: v))),
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: _supervisorNameController,
                                lableText: Strings.supervisorName,
                                validator: ValidationBuilder()
                                    .maxLength(255)
                                    .required()
                                    .build(),
                                onChanged: (v) => _pBloc.add(
                                    AddProjectEvent.updateProject(_pBloc.state
                                        .copyWith(supervisorName: v))),
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: _studentPhoneNumberController,
                                lableText: Strings.studentPhoneNumber,
                                validator: ValidationBuilder(isOptional: true)
                                    .phone()
                                    .build(),
                                onChanged: (v) => _pBloc.add(
                                    AddProjectEvent.updateProject(_pBloc.state
                                        .copyWith(
                                            studentPhoneNo:
                                                ValidationBuilder().a2e(v)))),
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: _abstractController,
                                validator: ValidationBuilder(isOptional: true)
                                    .minLength(20)
                                    .build(),
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
                              BlocBuilder<AddProjectBloc, AddProjectState>(
                                builder: (context, state) {
                                  return KeyWordsWidget(
                                    keywords: state.keywords ?? [],
                                    onKeyWordAdded: (kw) {
                                      var nkws = _pBloc.state.keywords!
                                        ..add(kw);
                                      _pBloc.add(AddProjectEvent.updateProject(
                                          _pBloc.state
                                              .copyWith(keywords: nkws)));
                                    },
                                    onkeyWordDeleted: (kw) {
                                      var kws = _pBloc.state.keywords!
                                        ..remove(kw);
                                      _pBloc.add(AddProjectEvent.updateProject(
                                          _pBloc.state
                                              .copyWith(keywords: kws)));
                                    },
                                  );
                                },
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
                                        AppYearPicker(
                                          selectedDate: state.graduationYear,
                                          onYearSelected: (y) {
                                            if (y != null) {
                                              _pBloc.add(
                                                  AddProjectEvent.updateProject(
                                                      state.copyWith(
                                                          graduationYear: y)));
                                            }
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        AppLevelDropDown(
                                          selectedLevel: state.level!,
                                          onLevelChanged: (lvl) {
                                            _pBloc.add(
                                                AddProjectEvent.updateProject(
                                                    _pBloc.state.copyWith(
                                                        level: lvl!)));
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
                    FilePickerWidget(
                      pickedFiles: _pBloc.state.files,
                      onFilesPicked: (f) {
                        _pBloc.add(AddProjectEvent.addFile(f));
                      },
                    ),
                    BlocBuilder<AddProjectBloc, AddProjectState>(
                      builder: (context, state) {
                        return Column(
                          children: state.files!
                              .map((e) => PickedFileCard(
                                    file: e,
                                    onDeletePressed: () {
                                      _pBloc.add(AddProjectEvent.updateProject(
                                          _pBloc.state.copyWith(
                                              files: state.files!..remove(e))));
                                    },
                                  ))
                              .toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                        width: 300,
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          if (_pBloc.state.files!.isEmpty) {
                            context.showSnackBar('الرجاء رفع تقرير المشروع',
                                isError: true);
                            return;
                          }
                          if (_pBloc.state.graduationYear == null) {
                            context.showSnackBar('الرجاء اختيار سنة التخرج',
                                isError: true);
                            return;
                          }
                          await _pBloc.submitProject(_pBloc.state);
                        },
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
