import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/profile.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ProfileApiService extends NyApiService {
  ProfileApiService({BuildContext? buildContext}) : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<Profile?> getProfile() async {
    return await network<Profile>(
        request: (request) => request.get("/member/MyPage/higakijin2/orders"),
    );
  }
}
