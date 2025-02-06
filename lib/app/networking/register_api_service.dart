import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/register.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class RegisterApiService extends NyApiService {
  RegisterApiService({BuildContext? buildContext}) : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<Register?> submit({ dynamic data }) async {
    return await network<Register>(
        request: (request) => request.post("/api/register", data: data),
    );
  }
}
