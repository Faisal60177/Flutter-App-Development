import 'package:flutter/material.dart';
import 'TaskPage.dart';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Task Manager",
      home: TaskPage(),
    );
  }
}