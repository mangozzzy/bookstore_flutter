import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/search_history.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class SearchHistoryApiService extends NyApiService {
  SearchHistoryApiService({BuildContext? buildContext}) : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<List<SearchHistory>?> findAll({ required int id }) async {
    return await network(
        request: (request) => request.get("/search-history/$id"),
    );
  }

  Future<dynamic> create({ required int id, required String keyword }) async {
    return await network(
      request: (request) => request.post("/search-history/$id?keyword=$keyword"),
    );
  }

  Future<dynamic> destroyAll({ required int id }) async {
    return await network(
      request: (request) => request.delete("/search-history/$id")
     );
  }

  Future<dynamic> destroy({ required int id, required String keyword }) async {
    return await network(
      request: (request) => request.delete("/search-history/$id/$keyword")
     );
  }
}
