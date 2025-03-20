import 'package:flutter_app/app/networking/comment_api_service.dart';

import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

class BooksController extends Controller {
  final _commentApiService = CommentApiService();

  @override
  construct(BuildContext context) {
    super.construct(context);
  }

  Future<void> handleLogin({
    required String content,
    required int bookId,
  }) async {
    await _commentApiService.submit(bookId: bookId, content: content);
  }
}
