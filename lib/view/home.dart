import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/projects/projects_bloc.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/project/projects_list/project_card.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/error_widget.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectsP = BlocProvider.of<ProjectsBloc>(context, listen: true);
    return Scaffold(
      // appBar: AppBar(
      // To hide the back button from the app bar
      //   leading: const SizedBox.shrink(),
      // ),
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
                    AppButton(
                      onPressed: () {
                        AutoRouter.of(context).push(const AddProjectRoute());
                      },
                      text: Strings.addProject,
                      textColor: Colors.black,
                      icon: const Icon(Icons.add),
                    ),
                    Text(
                      Strings.count(projectsP.state
                          .whenOrNull(data: (r) => r.count.toString())),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SizedBox(
                  child: projectsP.state.whenOrNull(
                      loading: () => const Center(
                          child: CircularProgressIndicator.adaptive()),
                      failure: (e) => AppErrorWidget(
                          errorMessage: e.readableMessage,
                          onRefresh: () {
                            projectsP.add(const ProjectsEvent.started());
                          }),
                      data: (ps) {
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
