import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/password_search.dart';
import 'package:flutter_app/app/models/verify_code.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class PasswordApiService extends NyApiService {
  PasswordApiService({BuildContext? buildContext})
      : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<VerifyCode?> verifyCode({
    required String email,
    required String authenticationCode,
  }) async {
    return await network<VerifyCode>(
      request: (request) => request.post(
        "/api/verify-code?email=${email}&authenticationCode=${authenticationCode}",
      ),
    );
  }

  Future<PasswordSearch?> search({
    required String email,
  }) async {
    return await network<PasswordSearch>(
      request: (request) => request.post(
        "/api/password_such?email=${email}",
      ),
    );
  }
}
