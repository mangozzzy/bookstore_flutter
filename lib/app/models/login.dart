import 'package:nylo_framework/nylo_framework.dart';

class Login extends Model {
  final String userId;
  final bool success;

  static StorageKey key = "login";
  
  Login({
    required this.userId,
    required this.success,
  }) : super(key: key);
  
  factory Login.fromJson(data) {
    return Login(
      userId: data['userId'],
      success: data['success'],
    );
  }

  @override
  toJson() {
    return {};
  }
}
