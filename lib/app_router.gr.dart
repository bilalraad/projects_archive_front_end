// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import 'models/project.dart' as _i7;
import 'view/home.dart' as _i1;
import 'view/project/add_project/add_project.dart' as _i2;
import 'view/project/edit_project/edit_project.dart' as _i3;
import 'view/project/project_details/project_details.dart' as _i4;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    MyHomeRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.MyHomeScreen());
    },
    AddProjectRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.AddProjectScreen());
    },
    EditProjectRoute.name: (routeData) {
      final args = routeData.argsAs<EditProjectRouteArgs>();
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.EditProjectScreen(key: args.key, project: args.project),
          maintainState: false);
    },
    ProjectDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProjectDetailsRouteArgs>(
          orElse: () =>
              ProjectDetailsRouteArgs(projectId: pathParams.getInt('id')));
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i4.ProjectDetailsScreen(
              key: args.key, projectId: args.projectId));
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(MyHomeRoute.name, path: '/'),
        _i5.RouteConfig(AddProjectRoute.name, path: '/projects/add'),
        _i5.RouteConfig(EditProjectRoute.name, path: '/edit-project-screen'),
        _i5.RouteConfig(ProjectDetailsRoute.name, path: '/projects/:id'),
        _i5.RouteConfig('/#redirect',
            path: '/', redirectTo: '/projects', fullMatch: true),
        _i5.RouteConfig('*#redirect',
            path: '*', redirectTo: '/projects', fullMatch: true)
      ];
}

/// generated route for
/// [_i1.MyHomeScreen]
class MyHomeRoute extends _i5.PageRouteInfo<void> {
  const MyHomeRoute() : super(MyHomeRoute.name, path: '/');

  static const String name = 'MyHomeRoute';
}

/// generated route for
/// [_i2.AddProjectScreen]
class AddProjectRoute extends _i5.PageRouteInfo<void> {
  const AddProjectRoute() : super(AddProjectRoute.name, path: '/projects/add');

  static const String name = 'AddProjectRoute';
}

/// generated route for
/// [_i3.EditProjectScreen]
class EditProjectRoute extends _i5.PageRouteInfo<EditProjectRouteArgs> {
  EditProjectRoute({_i6.Key? key, required _i7.Project project})
      : super(EditProjectRoute.name,
            path: '/edit-project-screen',
            args: EditProjectRouteArgs(key: key, project: project));

  static const String name = 'EditProjectRoute';
}

class EditProjectRouteArgs {
  const EditProjectRouteArgs({this.key, required this.project});

  final _i6.Key? key;

  final _i7.Project project;

  @override
  String toString() {
    return 'EditProjectRouteArgs{key: $key, project: $project}';
  }
}

/// generated route for
/// [_i4.ProjectDetailsScreen]
class ProjectDetailsRoute extends _i5.PageRouteInfo<ProjectDetailsRouteArgs> {
  ProjectDetailsRoute({_i6.Key? key, required int projectId})
      : super(ProjectDetailsRoute.name,
            path: '/projects/:id',
            args: ProjectDetailsRouteArgs(key: key, projectId: projectId),
            rawPathParams: {'id': projectId});

  static const String name = 'ProjectDetailsRoute';
}

class ProjectDetailsRouteArgs {
  const ProjectDetailsRouteArgs({this.key, required this.projectId});

  final _i6.Key? key;

  final int projectId;

  @override
  String toString() {
    return 'ProjectDetailsRouteArgs{key: $key, projectId: $projectId}';
  }
}
