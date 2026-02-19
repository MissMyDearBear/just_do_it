import 'package:flutter/material.dart';
import 'package:just_do_it/db/AppDatabase.dart';
import 'package:just_do_it/page/HomePage.dart';
import 'package:just_do_it/page/LoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      title: 'Bear Assist',
      routes: {'/': (context) => LoginPage(), '/home': (context) => HomePage()},
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}

final database = AppDatabase();
