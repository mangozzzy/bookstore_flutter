import 'package:nylo_framework/nylo_framework.dart';

class User extends Model {
  final int? id;
  final String? userId;
  final String? password;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? birthDate;
  final String? gender;
  final String? age;
  final String? cardType;
  final String? cardNumber;

  static StorageKey key = "register";
  
  User({
    required this.id,
    required this.userId,
    required this.password,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.birthDate,
    required this.gender,
    required this.age,
    this.cardType,
    this.cardNumber,
  }) : super(key: key);
  
  factory User.fromJson(data) {
    return User(
      id: data['id'],
      userId: data['userId'],
      password: data['password'],
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      birthDate: data['birthDate'],
      gender: data['gender'],
      age: data['age'],
      cardType: data['cardType'],
      cardNumber: data['cardNumber'],
    );
  }

  @override
  toJson() {
    return {};
  }
}
