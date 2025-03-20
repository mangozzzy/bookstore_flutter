import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/book.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class BooksApiService extends NyApiService {
  BooksApiService({BuildContext? buildContext}) : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<List<Book>?> findAll() async {
    return await network(
        request: (request) => request.get("/api/books"),
    );
  }

  Future<Book?> findOne(int id) async {
    return await network<Book>(
        request: (request) => request.get("/api/books/goods/$id"),
    );
  }
}
