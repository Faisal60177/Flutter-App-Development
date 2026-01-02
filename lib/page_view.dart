import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          onPageChanged: (pageIndex) {
            print('Current page: $pageIndex');
          },
          scrollDirection: Axis.vertical,
          children: [
            Container(color: Colors.red),
            Container(color: Colors.yellow),
            Container(color: Colors.green),
          ],
        ),
      ),
    );
  }
}
