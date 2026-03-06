import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/models/weather_model.dart';
import 'package:flutter_project/repo/weather_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/cubits/weather_cubit.dart';


class WeatherScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    context.read<WeatherCubit>().loadWeather();

    return Scaffold(
      appBar: AppBar(title: Text("Weather App"),backgroundColor: Colors.blue,),
      body: BlocBuilder<WeatherCubit,WeatherEvent>(
          builder:(context,state){
            final cubit = context.read<WeatherCubit>();
            // Loading State
            if(state == WeatherEvent.loading){
              return Center(child: CircularProgressIndicator(),);
            }
            if (state == WeatherEvent.failure){
              return Center(child: Text("Some thing Wrong"),);
            }

            final data= cubit.weatherModel;
            if (data == null){
              return Center(child: Text("No Data Found"),);
            }
            return Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Image.network(data.icon ?? "",width: 100,),
                  SizedBox(height: 30,),
                  Text("City Name: ${data.location}",style: TextStyle(fontSize: 32),),
                  SizedBox(height: 30,),
                  Text("Temp: ${data.tempC}",style: TextStyle(fontSize: 32),),
                  SizedBox(height: 30,),
                  Text("Condition: ${data.condition}",style: TextStyle(fontSize: 32),),
                ],
              ),
            );

          }
      ),
    );
  }

}