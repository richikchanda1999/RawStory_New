import 'package:flutter/material.dart';
import 'package:raw_story_new/BLoC/Auth.dart';
import 'package:raw_story_new/Login.dart';
import 'Home.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
