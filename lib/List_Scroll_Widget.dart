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
      appBar: AppBar(title: Text("Hello"), backgroundColor: Colors.blue),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: 40,

          itemBuilder: (context, index) {
            return Card(
              color: Colors.white70,
              child: ListTile(
                leading: Icon(Icons.ac_unit),
                title: Text('Number ${index + 1}'),
                subtitle: Text('Enter Now'),
                trailing: Icon(Icons.abc_sharp),
              ),
            );
          },
        ),
      ),
    );
  }
}
