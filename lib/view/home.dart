import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/projects/projects_bloc.dart';
import 'package:projects_archiving/data/strings.dart';
import 'package:projects_archiving/models/project.dart';
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
      body: Column(
        children: [
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  AutoRouter.of(context).push(const AddProjectRoute());
                },
                icon: const Icon(Icons.add),
                label: const Text(Strings.addProject),
              ),
            ],
          ),
          Expanded(
            child: Container(
              child: projectsP.state.whenOrNull(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (ps) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        border: const TableBorder(
                          horizontalInside: borderSide,
                          verticalInside: borderSide,
                        ),
                        columns: columns,
                        rows: ps.results
                            .map((e) => DataRow(cells: projectRow(e)))
                            .toList(),
                      ),
                    );
                  },
                  error: (e) => Text(e.raw.toString())),
            ),
          ),
        ],
      ),
    );
  }
}
