import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/counter_app.dart';
import 'counter_app.dart';
import 'main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counterBloc = context.read<CounterBloC>();
    return Scaffold(
      appBar: AppBar(title: Text("Counter APP")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CounterBloC, int>(
              builder: (context, count) {
                return Text(count.toString(), style: TextStyle(fontSize: 60));
              },
            ),

            ElevatedButton(
              onPressed: () => {counterBloc.add(Increment())},
              child: Text("+"),
            ),
            SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () => {counterBloc.add(Reset())},
              label: Text("RESET"),
              icon: Icon(Icons.clear),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => {counterBloc.add(Decrement())},
              child: Text("-"),
            ),
          ],
        ),
      ),
    );
  }
}
