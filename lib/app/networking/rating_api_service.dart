import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/profile_api_service.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class RatingApiService extends NyApiService {
  final _profileApiService = ProfileApiService();
  RatingApiService({BuildContext? buildContext}) : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<double> getAverage({
    required int bookId,
   }) async {
    return await network(
      request: (requeset) => requeset.get("/ratings/average?bookId=${bookId}}"),
    );
   }

  Future<dynamic> create({
    required int bookId,
    required int score
  }) async {
    final _profile = await _profileApiService.getProfile();
    return await network(
        request: (request) => request.post("/ratings?userId=${_profile!.id}&bookId=${bookId}&score=${score}"),
    );
  }
}
