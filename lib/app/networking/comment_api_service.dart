import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/profile_api_service.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/models/comment.dart';

class CommentApiService extends NyApiService {
  final _profileApiService = ProfileApiService();
  CommentApiService({BuildContext? buildContext})
      : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<List<Comment>?> getMyComments() async {
    final _profile = await _profileApiService.getProfile();
    return await network(
      request: (request) => request.get('/api/comments/user/${_profile!.id}'),
    );
  }

  Future<Comment?> submit(
      {required int bookId, required String content}) async {
    final _profile = await _profileApiService.getProfile();

    return await network<Comment>(
      request: (request) => request.post(
          "/api/comments/${bookId}?userId=${_profile?.id}&content=${content}"),
    );
  }

  Future<List<Comment>?> getListByBook({
    required int bookId,
  }) async {
    return await network(
      request: (request) => request.get("/api/comments/book/${bookId}"),
    );
  }
}
