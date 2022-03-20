import 'package:auto_route/annotations.dart';
import 'package:projects_archiving/view/home.dart';
import 'package:projects_archiving/view/project/add_project.dart';

@MaterialAutoRouter(replaceInRouteName: 'Screen,Route', routes: <AutoRoute>[
  AutoRoute(page: MyHomeScreen, initial: true),
  AutoRoute(page: AddProjectScreen, path: '/projects/add'),
  RedirectRoute(path: '*', redirectTo: '/projects'),
  RedirectRoute(path: '/', redirectTo: '/projects'),
])
class $AppRouter {}
