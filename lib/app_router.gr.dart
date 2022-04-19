// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;

import 'view/home.dart' as _i1;
import 'view/project/add_project/add_project.dart' as _i2;
import 'view/project/project_details/project_details.dart' as _i3;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    MyHomeRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.MyHomeScreen());
    },
    AddProjectRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.AddProjectScreen());
    },
    ProjectDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProjectDetailsRouteArgs>(
          orElse: () =>
              ProjectDetailsRouteArgs(projectId: pathParams.getInt('id')));
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.ProjectDetailsScreen(
              key: args.key, projectId: args.projectId));
    }
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(MyHomeRoute.name, path: '/'),
        _i4.RouteConfig(AddProjectRoute.name, path: '/projects/add'),
        _i4.RouteConfig(ProjectDetailsRoute.name, path: '/projects/:id'),
        _i4.RouteConfig('*#redirect',
            path: '*', redirectTo: '/projects', fullMatch: true),
        _i4.RouteConfig('/#redirect',
            path: '/', redirectTo: '/projects', fullMatch: true)
      ];
}

/// generated route for
/// [_i1.MyHomeScreen]
class MyHomeRoute extends _i4.PageRouteInfo<void> {
  const MyHomeRoute() : super(MyHomeRoute.name, path: '/');

  static const String name = 'MyHomeRoute';
}

/// generated route for
/// [_i2.AddProjectScreen]
class AddProjectRoute extends _i4.PageRouteInfo<void> {
  const AddProjectRoute() : super(AddProjectRoute.name, path: '/projects/add');

  static const String name = 'AddProjectRoute';
}

/// generated route for
/// [_i3.ProjectDetailsScreen]
class ProjectDetailsRoute extends _i4.PageRouteInfo<ProjectDetailsRouteArgs> {
  ProjectDetailsRoute({_i5.Key? key, required int projectId})
      : super(ProjectDetailsRoute.name,
            path: '/projects/:id',
            args: ProjectDetailsRouteArgs(key: key, projectId: projectId),
            rawPathParams: {'id': projectId});

  static const String name = 'ProjectDetailsRoute';
}

class ProjectDetailsRouteArgs {
  const ProjectDetailsRouteArgs({this.key, required this.projectId});

  final _i5.Key? key;

  final int projectId;

  @override
  String toString() {
    return 'ProjectDetailsRouteArgs{key: $key, projectId: $projectId}';
  }
}
