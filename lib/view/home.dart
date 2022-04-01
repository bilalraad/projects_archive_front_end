import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/projects/projects_bloc.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/models/project.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectsP = BlocProvider.of<ProjectsBloc>(context, listen: true);

    List<DataCell> projectRow(Project project) {
      return [
        DataCell(Text(project.name)),
        DataCell(Text(project.graduationYear.year.toString())),
        DataCell(Text(project.studentName)),
        DataCell(Text(project.supervisorName)),
        DataCell(Text(project.level.name)),
        DataCell(Text(project.keywords.toString())),
        DataCell(InkWell(
            onTap: () {
              launch(project.pdfUrl);
            },
            child: Text(
              "Url",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ))),
        DataCell(InkWell(
            onTap: () {
              launch(project.docUrl);
            },
            child: Text(
              "Url",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ))),
      ];
    }

    List<DataColumn> columns = const [
      DataColumn(label: Text(Strings.projectName)),
      DataColumn(label: Text(Strings.graduationYear)),
      DataColumn(label: Text(Strings.studentName)),
      DataColumn(label: Text(Strings.supervisorName)),
      DataColumn(label: Text(Strings.level)),
      DataColumn(label: Text(Strings.keywords)),
      DataColumn(label: Text(Strings.pdf)),
      DataColumn(label: Text(Strings.doc)),
    ];

    const borderSide =
        BorderSide(width: 0.5, color: Colors.black, style: BorderStyle.solid);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20)),
                      onPressed: () {
                        AutoRouter.of(context).push(const AddProjectRoute());
                      },
                      icon: const Icon(Icons.add),
                      label: const Text(Strings.addProject),
                    ),
                    Text(
                      Strings.count(projectsP.state
                          .whenOrNull(loaded: (r) => r.count.toString())),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SizedBox(
                  child: projectsP.state.whenOrNull(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e) => Text(e.raw.toString()),
                      loaded: (ps) {
                        return SingleChildScrollView(
                          child: Wrap(
                            children: ps.results
                                .map((p) => ProjectCard(p: p))
                                .toList(),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Project p;
  const ProjectCard({Key? key, required this.p}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pSubtitleStyle =
        Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.grey);
    final pSubtitleValueStyle = Theme.of(context).textTheme.bodyText1;
    return SizedBox(
      width: 400,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: "${Strings.studentName}\n",
                                style: pSubtitleStyle,
                                children: [
                              TextSpan(
                                  text: p.studentName,
                                  style: pSubtitleValueStyle)
                            ])),
                        RichText(
                            text: TextSpan(
                                text: "${Strings.graduationYear}\n",
                                style: pSubtitleStyle,
                                children: [
                              TextSpan(
                                  text: p.graduationYear.year.toString(),
                                  style: pSubtitleValueStyle)
                            ])),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: "${Strings.supervisorName}\n",
                                style: pSubtitleStyle,
                                children: [
                              TextSpan(
                                  text: p.supervisorName,
                                  style: pSubtitleValueStyle)
                            ])),
                        RichText(
                            text: TextSpan(
                                text: "${Strings.keywords}\n",
                                style: pSubtitleStyle,
                                children: [
                              TextSpan(
                                  text: p.keywords
                                      .toString()
                                      .replaceAll('[', '')
                                      .replaceAll(']', ''),
                                  style: pSubtitleValueStyle)
                            ])),
                      ],
                    ),
                  ),
                ],
              ),
              AppButton(
                  onPressed: () {},
                  width: 120,
                  backroundColor: Colors.black,
                  text: 'عرض التفاصيل'),
            ],
          ),
        ),
      ),
    );
  }
}
