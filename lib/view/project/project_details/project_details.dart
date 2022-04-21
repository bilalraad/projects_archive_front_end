import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:projects_archiving/blocs/project_details/project_details_cubit.dart';
import 'package:projects_archiving/utils/enums.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/error_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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
  @override
  void didChangeDependencies() {
    projectP = BlocProvider.of<ProjectDetailsBloc>(context, listen: true);
    projectP.state
        .whenOrNull(initial: () => projectP.getProject(widget.projectId));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    projectP.dispose();
    super.dispose();
  }

  late TextStyle? titleTextTheme;

  Widget titleWithValue(String? title, String? value) {
    return RichText(
        text: TextSpan(
            text: "$title\n",
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.grey),
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
      body: Center(
        child: projectP.state.whenOrNull(
          loading: () => const CircularProgressIndicator.adaptive(),
          failure: (e) => AppErrorWidget(
              errorMessage: e.readableMessage,
              onRefresh: () => projectP.getProject(widget.projectId)),
          data: (p) {
            return SingleChildScrollView(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AppBackButton(),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        p.name,
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
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 400,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Strings.keywords, style: titleTextTheme),
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
                                                  child: Text(
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
                                        child: Text('لا يوجد كلمات دالة'),
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
                        initialValue: p.abstract ?? 'لم يتم اضافة نبذة مختصرة',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('التقرير النهائي', style: titleTextTheme),
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
                                                backroundColor:
                                                    e.fileType == FileType.word
                                                        ? Colors.black
                                                        : null,
                                                onPressed: () =>
                                                    downLoadUrl(e.path),
                                                text: e.fileType.name),
                                          ))
                                      .toList(),
                                )
                              : const Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('لم يتم رفع تقرير لهذا المشروع'),
                                ),
                          const VerticalDivider(),
                          const Spacer(),
                          AppButton(
                              width: 150,
                              backroundColor: Colors.black,
                              buttonType: ButtonType.secondary,
                              onPressed: () {
                                //TODO: IMPLEMENT PROEJCT EDIT
                              },
                              text: 'تعديل المشروع'),
                          const SizedBox(width: 10),
                          AppButton(
                              width: 150,
                              backroundColor: Colors.red,
                              buttonType: ButtonType.secondary,
                              onPressed: () {
                                //TODO: IMPLEMENT PROJECT DELET
                              },
                              text: 'حذف المشروع'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

downLoadUrl(String path) {
  launch(dotenv.env['BASE_URL']! + "/$path");
}

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Align(
          alignment: Alignment.topRight,
          child: InkWell(
            onTap: () => AutoRouter.of(context).replaceNamed('/'),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios,
                    color: Theme.of(context).primaryColor),
                Text('رجوع',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
