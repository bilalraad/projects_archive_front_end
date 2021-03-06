import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/project_details/project_details_cubit.dart';
import 'package:projects_archiving/blocs/user/user_cubit.dart';
import 'package:projects_archiving/utils/download.dart';
import 'package:projects_archiving/utils/enums.dart';
import 'package:projects_archiving/utils/context_extentions.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/app_header.dart';
import 'package:projects_archiving/view/widgets/error_widget.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final int projectId;
  const ProjectDetailsScreen({
    Key? key,
    @PathParam('id') required this.projectId,
  }) : super(key: key);

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  late ProjectDetailsBloc projectP;
  late UserCubit _userB;

  @override
  void didChangeDependencies() {
    projectP = BlocProvider.of<ProjectDetailsBloc>(context, listen: true);
    _userB = BlocProvider.of<UserCubit>(context, listen: false);

    projectP.state
        .whenOrNull(initial: () => projectP.getProject(widget.projectId));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    projectP.reset();
    super.dispose();
  }

  late TextStyle? titleTextTheme;

  Widget titleWithValue(String? title, String? value) {
    return SelectableText.rich(TextSpan(
        text: "$title\n",
        style:
            Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.grey),
        children: [
          TextSpan(
              text: value,
              style:
                  Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    titleTextTheme =
        Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.grey);
    return Scaffold(
      body: AppHeader(
        child: SizedBox(
          child: projectP.state.whenOrNull(
            loading: () => const CircularProgressIndicator.adaptive(),
            failure: (e) => AppErrorWidget(
                errorMessage: e.readableMessage,
                onRefresh: () => projectP.getProject(widget.projectId)),
            data: (p) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: SelectableText(
                        p!.name,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(color: Colors.black),
                      ),
                    ),
                    Divider(
                        color: Theme.of(context).primaryColor, thickness: 2),
                    Wrap(
                      children: [
                        SizedBox(
                          width: 400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              titleWithValue(
                                  Strings.studentName, p.studentName),
                              titleWithValue(
                                  Strings.supervisorName, p.supervisorName),
                              titleWithValue(Strings.graduationYear,
                                  p.graduationYear.year.toString()),
                              titleWithValue(Strings.level, p.level.translate),
                              if (p.studentPhoneNo != null)
                                titleWithValue(Strings.studentPhoneNumber,
                                    p.studentPhoneNo),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(Strings.keywords,
                                  style: titleTextTheme),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).dividerColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 200,
                                width: double.infinity,
                                child: p.keywords.isNotEmpty
                                    ? GridView.count(
                                        crossAxisCount: 2,
                                        childAspectRatio: 30 / 10,
                                        children: p.keywords.map((e) {
                                          return Container(
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
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                  child: SelectableText(
                                                e,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              )),
                                            ),
                                          );
                                        }).toList(),
                                      )
                                    : const Align(
                                        alignment: Alignment.center,
                                        child: Text(Strings.noKeywords),
                                      ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(Strings.abstract, style: titleTextTheme),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        maxLines: 5,
                        readOnly: true,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        initialValue: p.abstract ?? Strings.noAbstract,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(Strings.projectFiles, style: titleTextTheme),
                    ),
                    SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          p.files.isNotEmpty
                              ? Row(
                                  children: p.files
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: AppButton(
                                              width: 150,
                                              backroundColor: e.fileType ==
                                                      ReportFileType.zip
                                                  ? Colors.black
                                                  : null,
                                              onPressed: () =>
                                                  downLoadFile(e.path),
                                              text: e.fileType !=
                                                      ReportFileType.zip
                                                  ? Strings.finalReport
                                                  : Strings.projectSourceCode,
                                            ),
                                          ))
                                      .toList(),
                                )
                              : const Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(Strings.noFiles),
                                ),
                          const VerticalDivider(),
                          const Spacer(),
                          if (_userB.isLoggedIn)
                            AppButton(
                                width: 150,
                                backroundColor: Colors.black,
                                buttonType: ButtonType.secondary,
                                onPressed: () {
                                  AutoRouter.of(context)
                                      .push(EditProjectRoute(project: p));
                                },
                                text: Strings.editProject),
                          const SizedBox(width: 10),
                          if (_userB.isLoggedIn)
                            AppButton(
                                width: 150,
                                backroundColor: Colors.red,
                                buttonType: ButtonType.secondary,
                                onPressed: () async {
                                  await projectP
                                      .deleteProject(widget.projectId);
                                  //FIXME: THIS TEMP FIX TO router problem when deleting project
                                  // ignore: use_build_context_synchronously
                                  AutoRouter.of(context).pop();
                                  projectP.state.whenOrNull(data: (_) {
                                    context.showSnackBar(
                                        Strings.deleteProjectSuccess);

                                    AutoRouter.of(context).replaceNamed('/');
                                  });
                                },
                                text: Strings.deleteProject),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
