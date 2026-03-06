import 'dart:convert';
import 'package:flutter_project/models/weather_model.dart';
import 'package:http/http.dart' as http;


class WeatherRepo{

  final String baseURL="http://api.weatherapi.com/v1/current.json?key=291e2d051e624ed488974910240410&q=Dhaka";

  Future<WeatherModel> fetchWeatherData() async{
    final response = await http.get(Uri.parse(baseURL));

    if (response.statusCode==200){
      final jsonData = jsonDecode(response.body);
      return WeatherModel.fromJson(jsonData);
    }else{
      throw Exception("Failed to load Data");
    }

  }

}