import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projects_archiving/app_router.gr.dart';
import 'package:projects_archiving/blocs/projects/projects_bloc.dart';
import 'package:projects_archiving/data/api/dio_client.dart';
import 'package:projects_archiving/data/api/helper/network.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/data/shared_pref_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final app = await configureInjections(MyApp());
  runApp(app);
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  final appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Projects Archiving',
      routerDelegate: AutoRouterDelegate(appRouter),
      routeInformationParser: appRouter.defaultRouteParser(),
      theme: ThemeData(primarySwatch: Colors.orange),
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
  await dotenv.load(fileName: "assets/.env");
  var _sharedPreference = await SharedPreferences.getInstance();
  var _sharedPreferenceHelper = SharedPreferenceHelper(_sharedPreference);
  var _dio = Network.provideDio(_sharedPreferenceHelper);
  var _dioClient = DioClient(_dio);
  var _projectsRepo = ProjectsApi(_dioClient, _sharedPreferenceHelper);

  return MultiBlocProvider(
    providers: [
      BlocProvider(
          lazy: false,
          create: (context) =>
              ProjectsBloc(_projectsRepo)..add(const ProjectsEvent.started())),
    ],
    child: child,
  );
}
