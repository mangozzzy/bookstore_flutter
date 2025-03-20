import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/profile.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ProfileApiService extends NyApiService {
  ProfileApiService({BuildContext? buildContext}) : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<Profile?> getProfile() async {
    final userId = await storageRead("userId");
    return await network<Profile>(
        request: (request) => request.post("/api/infofind?userId=${userId}"),
    );
  }

  Future<dynamic> deleteUser() async {
    final currentUserId = await Auth.data()['userId'];
    final currentUserPassword = await storageRead('password');

    final res = await network<dynamic>(request: (request) => request.delete('/member/MyPage/${currentUserId}', queryParameters: { "password": currentUserPassword }));
    await Auth.logout();

    return res;
  }
}
