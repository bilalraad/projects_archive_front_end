import 'package:flutter/material.dart';
import 'package:projects_archiving/models/project.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';

class ProjectCard extends StatelessWidget {
  final Project p;
  const ProjectCard({Key? key, required this.p}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pSubtitleStyle =
        Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.grey);
    final pSubtitleValueStyle = Theme.of(context).textTheme.bodyText1;
    Widget titleWithValue(String? title, String? value) {
      return RichText(
          text: TextSpan(
              text: "$title\n",
              style: pSubtitleStyle,
              children: [TextSpan(text: value, style: pSubtitleValueStyle)]));
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
                        titleWithValue(Strings.keywords, p.supervisorName),
                        titleWithValue(
                            Strings.supervisorName,
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
