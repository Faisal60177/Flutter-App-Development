import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/screen/AlarmFragment.dart';
import 'package:flutter_project/screen/EmailFragment.dart';
import 'package:flutter_project/screen/HomeFragment.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  MySnackBar(context, msg) {
    return ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg)));
  }

  List<Tab> tabs = [
    Tab(icon: Icon(Icons.home), text: "Home"),
    Tab(icon: Icon(Icons.email), text: "Email"),
    Tab(icon: Icon(Icons.alarm), text: "Alarm"),
  ];

  List<Widget> Fragments = [HomeFragment(), EmailFragment(), AlarmFragment()];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Flutter Project"),
          bottom: TabBar(
            isScrollable: false,
            tabAlignment: TabAlignment.fill,
            tabs: tabs,
          ),
        ),
        body: TabBarView(children: Fragments),
      ),
    );
  }
}
