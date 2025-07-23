import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:todo_notification/pages/home_screen.dart';
import 'package:todo_notification/pages/intro_screen.dart';

void main() async {
  // ensure widgets are initialized before async
  WidgetsFlutterBinding.ensureInitialized();

  //init the hive
  await Hive.initFlutter();

  //open a box(box is the term used in flutter for db,create database)
  await Hive.openBox("mybox");

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<bool> _firstRun() async {
    return await IsFirstRun.isFirstRun();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _firstRun(),
        builder: (context, snapshot) {
          // Still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Error occurred
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text("Something went wrong")),
            );
          }

          // Show IntroScreen on first run, else HomeScreen
          return snapshot.data == true ? IntroScreen() : HomeScreen();
        },
      ),
    );
  }
}
