import 'package:nylo_framework/nylo_framework.dart';

class VerifyCode extends Model {
  final String message;
  final String password;

  static StorageKey key = "verify_code";

  VerifyCode({
    required this.message,
    required this.password,
  }) : super(key: key);

  factory VerifyCode.fromJson(data) {
    return VerifyCode(
      message: data['message'],
      password: data['password'],
    );
  }

  @override
  toJson() {
    return {};
  }
}
