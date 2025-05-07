import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/book.dart';
import 'package:flutter_app/app/networking/rating_api_service.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class BooksApiService extends NyApiService {
  final _ratingApiService = RatingApiService();
  BooksApiService({BuildContext? buildContext}) : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<List<Book>?> findAll() async {
    final books = await network<List<Book>>(
        request: (request) => request.get("/api/books"),
    );
    if (books != null) {
      for (var book in books) {
        final averageRating = await _ratingApiService.getAverage(bookId: book.bookId);
        book.averageRating = averageRating;
      }
    }
    return books;
  }

  Future<Book?> findOne(int id) async {
    return await network<Book>(
        request: (request) => request.get("/api/books/goods/$id"),
    );
  }
}
