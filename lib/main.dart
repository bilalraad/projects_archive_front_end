import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_archiving/blocs/projects/projects_bloc.dart';
import 'package:projects_archiving/data/api/dio_client.dart';
import 'package:projects_archiving/data/api/helper/network.dart';
import 'package:projects_archiving/data/api/projects_api.dart';
import 'package:projects_archiving/data/shared_pref_helper.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(color: Colors.black),
    );
  }
}

Future<Widget> configureInjections(Widget child) async {
  await dotenv.load(fileName: ".env");
  var _sharedPreference = await SharedPreferences.getInstance();
  var _sharedPreferenceHelper = SharedPreferenceHelper(_sharedPreference);
  var _dio = Network.provideDio(_sharedPreferenceHelper);
  var _dioClient = DioClient(_dio);
  var _projectsRepo = ProjectsApi(_dioClient, _sharedPreferenceHelper);
  return MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (context) =>
              ProjectsBloc(_projectsRepo)..add(const ProjectsEvent.started())),
    ],
    child: child,
  );
}
