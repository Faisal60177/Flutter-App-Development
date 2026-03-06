import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/models/weather_model.dart';
import 'package:flutter_project/repo/weather_repo.dart';

enum WeatherEvent {initial,loading,success,failure}

class WeatherCubit extends Cubit<WeatherEvent>{

  final WeatherRepo weatherRepo;
  WeatherModel? weatherModel;
  WeatherCubit(this.weatherRepo):super(WeatherEvent.initial);

  Future loadWeather() async{
    try{
      emit(WeatherEvent.loading);
      weatherModel= await weatherRepo.fetchWeatherData();
      emit(WeatherEvent.success);
    }catch(e){
      emit(WeatherEvent.failure);
    }
  }
}