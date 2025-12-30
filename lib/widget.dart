import 'package:flutter/material.dart';

class ExamplesWidget extends StatelessWidget {
  const ExamplesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Common Widgets', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        width: double.infinity,
        height: 100,
        color: Colors.grey[300],
        child: FittedBox(
          child: Text(
            'This is very long text',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 50,
              color: Colors.deepOrange,
            ),
          ),
        ),
      ),
    );
  }
}
