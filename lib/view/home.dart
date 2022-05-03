import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/user/user_cubit.dart';
import 'package:projects_archiving/utils/strings.dart';

import 'project/projects_list/project_list.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userB = BlocProvider.of<UserCubit>(context, listen: false);
    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(child: ProjectsList()),
            ),
          ),
          Container(
            width: 100,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20),
                if (_userB.isLoggedIn)
                  SideBarItem(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      AutoRouter.of(context).push(const AddProjectRoute());
                    },
                    title: Strings.addProject,
                  ),
                if (_userB.isLoggedIn)
                  SideBarItem(
                    icon: const Icon(Icons.file_upload_outlined),
                    onPressed: () {
                      AutoRouter.of(context).replace(const BulkUploadRoute());
                    },
                    title: Strings.addProjects,
                  ),
                if (_userB.isLoggedIn)
                  SideBarItem(
                    icon: const Icon(Icons.person_add),
                    onPressed: () {
                      AutoRouter.of(context).replace(const AddAdminRoute());
                    },
                    title: 'اضافة ادمن',
                  ),
                if (!_userB.isLoggedIn)
                  SideBarItem(
                    icon: const Icon(Icons.login),
                    onPressed: () {
                      AutoRouter.of(context).replace(const LogInRoute());
                    },
                    title: Strings.logIn,
                  ),
                const Spacer(),
                if (_userB.isLoggedIn)
                  SideBarItem(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      await _userB.logOut();
                      AutoRouter.of(context).replace(const LogInRoute());
                    },
                    title: Strings.logOut,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SideBarItem extends StatelessWidget {
  final Icon icon;
  final String? title;
  final VoidCallback onPressed;
  const SideBarItem(
      {Key? key, required this.icon, this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            icon,
            Text(title ?? '', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
