import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/models/project.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';

class ProjectCard extends StatelessWidget {
  final Project p;
  const ProjectCard({Key? key, required this.p}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget titleWithValue(String? title, String? value) {
      return RichText(
          text: TextSpan(
              text: "$title\n",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.grey),
              children: [
            TextSpan(text: value, style: Theme.of(context).textTheme.bodyText1)
          ]));
    }

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
                        titleWithValue(Strings.studentName, p.studentName),
                        titleWithValue(Strings.graduationYear,
                            p.graduationYear.year.toString()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleWithValue(
                            Strings.supervisorName, p.supervisorName),
                        titleWithValue(
                            Strings.keywords,
                            p.keywords
                                .toString()
                                .replaceAll('[', '')
                                .replaceAll(']', '')),
                      ],
                    ),
                  ),
                ],
              ),
              AppButton(
                  onPressed: () {
                    AutoRouter.of(context)
                        .push(ProjectDetailsRoute(projectId: p.id));
                  },
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
