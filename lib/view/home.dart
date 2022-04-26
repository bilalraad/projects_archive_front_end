import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/projects/projects_bloc.dart';
import 'package:projects_archiving/blocs/user/user_cubit.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/project/projects_list/project_card.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';
import 'package:projects_archiving/view/widgets/error_widget.dart';
import 'package:projects_archiving/view/widgets/projects_filter_dilaog.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectsP = BlocProvider.of<ProjectsBloc>(context, listen: true);
    final _userB = BlocProvider.of<UserCubit>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Container(
                constraints: const BoxConstraints(maxWidth: double.infinity),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_userB.isLoggedIn)
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
                    ),
                    AppButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => const FilterDialog());
                      },
                      buttonType: ButtonType.secondary,
                      text: 'فلترة',
                      textColor: Colors.black,
                      icon: const Icon(Icons.filter_alt),
                    ),
                    if (_userB.isLoggedIn)
                      AppButton(
                        onPressed: () async {
                          await _userB.logOut();
                          AutoRouter.of(context).replace(const LogInRoute());
                        },
                        text: Strings.logOut,
                        textColor: Colors.black,
                        icon: const Icon(Icons.logout),
                      ),
                    if (!_userB.isLoggedIn)
                      AppButton(
                        onPressed: () {
                          AutoRouter.of(context).replace(const LogInRoute());
                        },
                        text: Strings.logIn,
                        textColor: Colors.black,
                        icon: const Icon(Icons.login),
                      ),
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
                          child: Center(
                            child: Wrap(
                              children: ps.results
                                  .map((p) => ProjectCard(p: p))
                                  .toList(),
                            ),
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
