import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddNumber extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddNumberState();
  }
}

class AddNumberState extends State<AddNumber> {
  double num1 = 0;
  double num2 = 0;
  double sum = 0;
  String title = "Adding App";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adding App"), backgroundColor: Colors.blue),

      backgroundColor: Colors.grey,
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Center(
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    num1 = double.parse(value);
                  });
                },
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),

              SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  setState(() {
                    num2 = double.parse(value);
                  });
                },
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    sum = num1 + num2;
                  });
                },
                child: Text("Add Number"),
              ),

              SizedBox(height: 20),

              Text(
                "Sum is ${sum.toString()}",
                style: TextStyle(color: Colors.black, fontSize: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
