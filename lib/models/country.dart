import 'package:equatable/equatable.dart';

class Country extends Equatable{
  final  int? id;
  final  String? name;
  final  String? capital;
  final  String? shortDescription;
  final  String? flag;

  Country({this.id, this.name, this.capital, this.shortDescription, this.flag});


  // De-Serialization --> JSON to Dart Object
  factory Country.fromJson(Map<String, dynamic> json){
    return Country(
      id: json['id'],
      name: json['name'],
      capital: json['capital'],
      shortDescription: json['short_description'],
      flag: json['flag'],

    );
  }

  // Serialization --> Dart Object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id']= id;
    data['name'] = name;
    data['capital'] = capital;
    data['short_description'] = shortDescription;
    data['flag'] = flag;
    return data;
  }

  @override
  List<Object?> get props => [id, name, capital, shortDescription, flag];

}

