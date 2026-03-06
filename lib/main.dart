import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/models/weather_model.dart';
import 'package:flutter_project/repo/weather_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/cubits/weather_cubit.dart';
import 'package:flutter_project/screens/weather_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context)=>WeatherCubit(WeatherRepo())
          )
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: WeatherScreen())
    );
  }

}
