// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;

import 'models/project.dart' as _i11;
import 'view/add_admin/add_admin.dart' as _i3;
import 'view/backup/backup.dart' as _i6;
import 'view/home.dart' as _i1;
import 'view/login/login.dart' as _i2;
import 'view/project/add_project/add_project.dart' as _i4;
import 'view/project/add_project/bulk_upload.dart' as _i5;
import 'view/project/edit_project/edit_project.dart' as _i8;
import 'view/project/project_details/project_details.dart' as _i7;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    MyHomeRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.MyHomeScreen());
    },
    LogInRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.LogInScreen());
    },
    AddAdminRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.AddAdminScreen());
    },
    AddProjectRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.AddProjectScreen());
    },
    BulkUploadRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i5.BulkUploadScreen());
    },
    BackupRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i6.BackupScreen());
    },
    ProjectDetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProjectDetailsRouteArgs>(
          orElse: () =>
              ProjectDetailsRouteArgs(projectId: pathParams.getInt('id')));
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.ProjectDetailsScreen(
              key: args.key, projectId: args.projectId),
          maintainState: false);
    },
    EditProjectRoute.name: (routeData) {
      final args = routeData.argsAs<EditProjectRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i8.EditProjectScreen(key: args.key, project: args.project));
    }
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(MyHomeRoute.name, path: '/'),
        _i9.RouteConfig(LogInRoute.name, path: '/admins/login'),
        _i9.RouteConfig(AddAdminRoute.name, path: '/admins/add'),
        _i9.RouteConfig(AddProjectRoute.name, path: '/projects/add'),
        _i9.RouteConfig(BulkUploadRoute.name, path: '/projects/bulkUpload'),
        _i9.RouteConfig(BackupRoute.name, path: '/projects/backup'),
        _i9.RouteConfig(ProjectDetailsRoute.name, path: '/projects/:id'),
        _i9.RouteConfig(EditProjectRoute.name, path: '/edit-project-screen'),
        _i9.RouteConfig('*#redirect',
            path: '*', redirectTo: '/projects', fullMatch: true),
        _i9.RouteConfig('/#redirect',
            path: '/', redirectTo: '/projects', fullMatch: true)
      ];
}

/// generated route for
/// [_i1.MyHomeScreen]
class MyHomeRoute extends _i9.PageRouteInfo<void> {
  const MyHomeRoute() : super(MyHomeRoute.name, path: '/');

  static const String name = 'MyHomeRoute';
}

/// generated route for
/// [_i2.LogInScreen]
class LogInRoute extends _i9.PageRouteInfo<void> {
  const LogInRoute() : super(LogInRoute.name, path: '/admins/login');

  static const String name = 'LogInRoute';
}

/// generated route for
/// [_i3.AddAdminScreen]
class AddAdminRoute extends _i9.PageRouteInfo<void> {
  const AddAdminRoute() : super(AddAdminRoute.name, path: '/admins/add');

  static const String name = 'AddAdminRoute';
}

/// generated route for
/// [_i4.AddProjectScreen]
class AddProjectRoute extends _i9.PageRouteInfo<void> {
  const AddProjectRoute() : super(AddProjectRoute.name, path: '/projects/add');

  static const String name = 'AddProjectRoute';
}

/// generated route for
/// [_i5.BulkUploadScreen]
class BulkUploadRoute extends _i9.PageRouteInfo<void> {
  const BulkUploadRoute()
      : super(BulkUploadRoute.name, path: '/projects/bulkUpload');

  static const String name = 'BulkUploadRoute';
}

/// generated route for
/// [_i6.BackupScreen]
class BackupRoute extends _i9.PageRouteInfo<void> {
  const BackupRoute() : super(BackupRoute.name, path: '/projects/backup');

  static const String name = 'BackupRoute';
}

/// generated route for
/// [_i7.ProjectDetailsScreen]
class ProjectDetailsRoute extends _i9.PageRouteInfo<ProjectDetailsRouteArgs> {
  ProjectDetailsRoute({_i10.Key? key, required int projectId})
      : super(ProjectDetailsRoute.name,
            path: '/projects/:id',
            args: ProjectDetailsRouteArgs(key: key, projectId: projectId),
            rawPathParams: {'id': projectId});

  static const String name = 'ProjectDetailsRoute';
}

class ProjectDetailsRouteArgs {
  const ProjectDetailsRouteArgs({this.key, required this.projectId});

  final _i10.Key? key;

  final int projectId;

  @override
  String toString() {
    return 'ProjectDetailsRouteArgs{key: $key, projectId: $projectId}';
  }
}

/// generated route for
/// [_i8.EditProjectScreen]
class EditProjectRoute extends _i9.PageRouteInfo<EditProjectRouteArgs> {
  EditProjectRoute({_i10.Key? key, required _i11.Project project})
      : super(EditProjectRoute.name,
            path: '/edit-project-screen',
            args: EditProjectRouteArgs(key: key, project: project));

  static const String name = 'EditProjectRoute';
}

class EditProjectRouteArgs {
  const EditProjectRouteArgs({this.key, required this.project});

  final _i10.Key? key;

  final _i11.Project project;

  @override
  String toString() {
    return 'EditProjectRouteArgs{key: $key, project: $project}';
  }
}
