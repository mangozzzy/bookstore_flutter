import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/login.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class LoginApiService extends NyApiService {
  LoginApiService({BuildContext? buildContext}) : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<Login?> submit({ dynamic data }) async {
    return await network<Login>(
        // ---Danger! : this endpoint is NOT "/login"
        request: (request) => request.post("/register",  data: data),
    );
  }
}
