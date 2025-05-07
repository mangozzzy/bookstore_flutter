import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/search_history.dart';
import 'package:flutter_app/app/networking/profile_api_service.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class SearchHistoryApiService extends NyApiService {
  final _profileApiService = ProfileApiService();

  SearchHistoryApiService({BuildContext? buildContext}) : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<List<SearchHistory>?> findAll() async {
    final _profile = await _profileApiService.getProfile();

    return await network(
        request: (request) => request.get("/api/search-history/${_profile!.id}"),
    );
  }

  Future<dynamic> create({  required String keyword }) async {
    final _profile = await _profileApiService.getProfile();
    return await network(
      request: (request) => request.post("/api/search-history/${_profile!.id}?keyword=$keyword"),
    );
  }

  Future<dynamic> destroyAll() async {
    final _profile = await _profileApiService.getProfile();
    return await network(
      request: (request) => request.delete("/api/search-history/${_profile!.id}")
     );
  }

  Future<dynamic> destroy({required String keyword }) async {
    final _profile = await _profileApiService.getProfile();
    return await network(
      request: (request) => request.delete("/api/search-history/${_profile!.id}/keyword?keyword=$keyword")
     );
  }
}
