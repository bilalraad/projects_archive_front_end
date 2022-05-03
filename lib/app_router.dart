import 'package:auto_route/annotations.dart';
import 'package:projects_archiving/view/add_admin/add_admin.dart';
import 'package:projects_archiving/view/home.dart';
import 'package:projects_archiving/view/login/login.dart';
import 'package:projects_archiving/view/project/add_project/add_project.dart';
import 'package:projects_archiving/view/project/edit_project/edit_project.dart';
import 'package:projects_archiving/view/project/project_details/project_details.dart';

@MaterialAutoRouter(replaceInRouteName: 'Screen,Route', routes: <AutoRoute>[
  AutoRoute(page: MyHomeScreen, initial: true),
  AutoRoute(page: LogInScreen, path: '/admins/login'),
  AutoRoute(page: AddAdminScreen, path: '/admins/add'),
  AutoRoute(page: AddProjectScreen, path: '/projects/add'),
  AutoRoute(
      page: ProjectDetailsScreen, path: '/projects/:id', maintainState: false),
  AutoRoute(page: EditProjectScreen),
  RedirectRoute(path: '*', redirectTo: '/projects'),
  RedirectRoute(path: '/', redirectTo: '/projects'),
])
class $AppRouter {}
