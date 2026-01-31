import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CounterPageState();
  }
}

class CounterPageState extends State<CounterPage> {
  int num1 = 0;
  int num2 = 0;
  int count = 0;
  String title = "Counter App";

  counter() {
    setState(() {
      count = count + 1;
      title = "Counter App ${count.toString()}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Counter App"),
        titleTextStyle: TextStyle(color: Colors.deepPurple),
      ),

      body: Center(child: Text(count.toString())),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
