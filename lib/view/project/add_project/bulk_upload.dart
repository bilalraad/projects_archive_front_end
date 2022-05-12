import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/add_project/add_project_bloc.dart';
import 'package:projects_archiving/models/app_file.dart';
import 'package:projects_archiving/utils/enums.dart';
import 'package:projects_archiving/utils/context_extentions.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/project/add_project/file_picker_widget.dart';
import 'package:projects_archiving/view/project/project_details/project_details.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';

class BulkUploadScreen extends StatefulWidget {
  const BulkUploadScreen({Key? key}) : super(key: key);

  @override
  State<BulkUploadScreen> createState() => _BulkUploadScreenState();
}

class _BulkUploadScreenState extends State<BulkUploadScreen> {
  late AddProjectBloc _pBloc;
  AppFile? _excelFile;

  @override
  void initState() {
    _pBloc = BlocProvider.of<AddProjectBloc>(context);

    super.initState();
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
                child: Column(
                  children: [
                    Text(
                      Strings.addProjects,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: Colors.black),
                    ),
                    FilePickerWidget(
                      filesLimit: 1,
                      fileTypes: const [PickerFileTypes.xlsx],
                      pickedFiles: _excelFile != null ? [_excelFile!] : [],
                      onFilesPicked: (f) => setState(() => _excelFile = f),
                      onFileRemoved: (f) => setState(() => _excelFile = null),
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                        width: 300,
                        isLoading: _pBloc.state.maybeWhen(
                            loading: () => true, orElse: () => false),
                        onPressed: () async {
                          if (_excelFile == null) {
                            context.showSnackBar(Strings.pleaseUploadFile,
                                isError: true);
                            return;
                          }
                          await _pBloc.projectsUpload(_excelFile!);
                          _pBloc.state.whenOrNull(data: (results) {
                            context.showSnackBar(Strings.projectsUploadSuccess);
                            AutoRouter.of(context).replace(const MyHomeRoute());
                          }, failure: (e) {
                            context.showSnackBar(e.readableMessage,
                                isError: true);
                            return;
                          });
                        },
                        text: Strings.add),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
