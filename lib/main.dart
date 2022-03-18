import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projects_archiving/blocs/projects/projects_bloc.dart';
import 'package:projects_archiving/data/api/dio_client.dart';
import 'package:projects_archiving/data/api/helper/network.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/data/shared_pref_helper.dart';
import 'package:projects_archiving/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(await configureInjections(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projects Archiving',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar')],
      home: const MyHomePage(),
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
