class Country {
  int? id;
  String? name;
  String? capital;
  String? shortDescription;
  String? flag;

  Country({this.id, this.name, this.capital, this.shortDescription, this.flag});
  factory Country.fromJson(Map<String, dynamic> json){
    return Country(
    id: json['id'],
    name: json['name'],
    capital: json['capital'],
    shortDescription : json['short_description'],
    flag: json['flag'],
  );
  }
   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['capital'] = capital;
    data['short_description'] = shortDescription;
    data['flag'] = flag;
    return data;
  }
}

// Serialization --> Dart Object to JSON
// De-Serialization --> JSON to Dart Object