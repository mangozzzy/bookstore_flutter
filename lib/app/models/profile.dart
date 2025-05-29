import 'package:nylo_framework/nylo_framework.dart';

class Profile extends Model {
  final int? id;
  final String? userId;
  final String? password;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? birthDate;
  final String? gender;
  final int? age;
  final String? cardNumber;
  final String? cardType;
  final String? bankAccount;

  static StorageKey key = "profile";
  
  Profile({
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
    required this.cardNumber,
    required this.cardType,
    required this.bankAccount,
  }) : super(key: key);
  
  factory Profile.fromJson(data) {
    return Profile(
      id: data['id'],
      userId: data['userId'],
      password: data['password'],
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      birthDate: data['birthDate'],
      gender: data['gender'],
      age: data['age'] != null ? int.tryParse(data['age'].toString()) : null,
      cardNumber: data['cardNumber'],
      cardType: data['cardType'],
      bankAccount: data['bankAccount'],
    );
  }

  @override
  toJson() {
    return {};
  }
}
