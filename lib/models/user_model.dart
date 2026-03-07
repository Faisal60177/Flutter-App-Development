// User Model - Represents a user document in Firestore

class UserModel {
  final String? id; // Document ID
  final String name;
  final String email;
  final int age;
  final String city;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> hobbies;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.city,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.hobbies = const [],
});
// Convert UserModel to Map for Firestore
Map<String, dynamic> toMap(){
  return{
    'name' : name,
    'email': email,
    'age': age,
    'city': city,
    'isActive': isActive,
    'hobbies': hobbies,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String()
  };
}
// Create UserModel from Firestore document
factory UserModel.fromMap(String id, Map<String, dynamic> map){
  return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      age: map['age'] ?? 0,
      city: map['city'] ?? '',
      isActive: map['isActive'] ?? true,
      hobbies: List<String>.from(map['hobbies'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
  );
}

UserModel CopyWith({
    String? id,
  String? name,
  String? email,
  int? age,
  String? city,
  bool? isActive,
  DateTime? createdAt,
  DateTime? updatedAt,
  List<String>? hobbies,
}) {
  return UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    age: age ?? this.age,
    city: city ?? this.city,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    hobbies: hobbies ?? this.hobbies,
  );
}

@override
  String toString(){
  return 'UserModel(id: $id, name: $name, email: $email, age: $age, city: $city)';
}

}