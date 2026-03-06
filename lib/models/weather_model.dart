class WeatherModel {
  // Variable
  final String location;
  final double tempC;
  final String condition;
  final String icon;

  // Constructor
  WeatherModel({
    required this.location,
    required this.tempC,
    required this.condition,
    required this.icon
  });

  // factory Constructor
  factory WeatherModel.fromJson(Map<String,dynamic> json){
    return WeatherModel(
        location:json["location"]["name"],
        tempC:json["current"]["temp_c"],
        condition:json["current"]["condition"]["text"],
        icon:"https:${json["current"]["condition"]["icon"]}"
    );
  }
}