import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/user/user_cubit.dart';
import 'package:projects_archiving/utils/strings.dart';
import 'package:projects_archiving/view/widgets/app_button.dart';

import 'project/projects_list/project_list.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  children: [
                    if (_userB.isLoggedIn)
                      AppButton(
                        onPressed: () {
                          AutoRouter.of(context).push(const AddProjectRoute());
                        },
                        text: Strings.addProject,
                        icon: const Icon(Icons.add),
                      ),
                    const Spacer(),
                    if (_userB.isLoggedIn)
                      AppButton(
                        onPressed: () async {
                          await _userB.logOut();
                          AutoRouter.of(context).replace(const LogInRoute());
                        },
                        text: Strings.logOut,
                        buttonType: ButtonType.secondary,
                        icon: Icon(Icons.logout,
                            color: Theme.of(context).primaryColor),
                      ),
                    if (!_userB.isLoggedIn)
                      AppButton(
                        onPressed: () {
                          AutoRouter.of(context).replace(const LogInRoute());
                        },
                        text: Strings.logIn,
                        icon: const Icon(Icons.login),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const ProjectsList(),
            ],
          ),
        ),
      ),
    );
  }
}
