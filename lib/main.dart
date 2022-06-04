import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/add_project/add_project_bloc.dart';
import 'package:projects_archiving/blocs/backupAndRestore/backupandrestore_cubit.dart';
import 'package:projects_archiving/blocs/edit_project/edit_project_bloc.dart';
import 'package:projects_archiving/blocs/password_manager/password_manager_cubit.dart';
import 'package:projects_archiving/blocs/project_details/project_details_cubit.dart';
import 'package:projects_archiving/blocs/projects/projects_bloc.dart';
import 'package:projects_archiving/blocs/projects_filter/projects_filter_bloc.dart';
// import 'package:projects_archiving/blocs/teachers_and_students/graduates_cubit.dart';
import 'package:projects_archiving/blocs/teachers_and_students/teachers_cubit.dart';
import 'package:projects_archiving/blocs/user/user_cubit.dart';
import 'package:projects_archiving/data/api/dio_client.dart';
import 'package:projects_archiving/data/api/helper/network.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/data/shared_pref_helper.dart';
import 'package:projects_archiving/utils/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final app = await configureInjections(MyApp());
  runApp(app);
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Projects Archiving',
      routerDelegate: AutoRouterDelegate(appRouter),
      routeInformationParser: appRouter.defaultRouteParser(),
      theme: ThemeData(
          primarySwatch: buildMaterialColor(const Color(0xFFF95F05)),
          fontFamily: 'notoKufi'),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar')],
    );
  }
}

Future<Widget> configureInjections(Widget child) async {
  await dotenv.load(fileName: "assets/mobile.env");
  var sharedPreference = await SharedPreferences.getInstance();
  var sharedPrefHelper = SharedPreferenceHelper(sharedPreference);
  var dio = Network.provideDio(sharedPrefHelper);
  var dioClient = DioClient(dio);
  var projectsRepo = ProjectsApi(dioClient, sharedPrefHelper);
  var filter = ProjectsFilterBloc();
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => filter),
      BlocProvider(
          lazy: false, create: (context) => ProjectsBloc(projectsRepo, filter)),
      BlocProvider(create: (_) => AddProjectBloc(projectsRepo)),
      BlocProvider(create: (_) => EditProjectBloc(projectsRepo)),
      BlocProvider(create: (_) => ProjectDetailsBloc(projectsRepo)),
      BlocProvider(create: (_) => UserCubit(projectsRepo, sharedPrefHelper)),
      BlocProvider(create: (_) => BackupandrestoreCubit(projectsRepo)),
      BlocProvider(create: (_) => PasswordManagerCubit(projectsRepo)),
      BlocProvider(create: (_) => TeachersCubit(projectsRepo)),
      // BlocProvider(create: (_) => GraduatesCubit(projectsRepo)),
    ],
    child: child,
  );
}
