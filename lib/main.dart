import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/counter_app.dart';
import 'counter_home_page.dart';
import 'counter_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      home: MultiBlocProvider(
        providers: [BlocProvider<CounterBloC>(create: (_) => CounterBloC())],
        child: CounterPage(),
      ),
    );
  }
}
