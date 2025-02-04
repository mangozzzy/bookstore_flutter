import 'package:nylo_framework/nylo_framework.dart';

class Register extends Model {
  final String? userId;
  final String? password;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? birthDate;
  final String? gender;
  final String? age;

  static StorageKey key = "register";
  
  Register({
      required this.userId,
    required this.password,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.birthDate,
    required this.gender,
    required this.age,
  }) : super(key: key);
  
  factory Register.fromJson(data) {
    return Register(
      userId: data['userId'],
      password: data['password'],
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      birthDate: data['birthDate'],
      gender: data['gender'],
      age: data['age'],
    );
  }

  @override
  toJson() {
    return {};
  }
}
