import 'package:flutter_app/app/models/book.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:nylo_framework/nylo_framework.dart';

class Comment extends Model {
  final String content;
  final Book? book;
  final User? user;

  static StorageKey key = "comment";
  
  Comment({
    required this.content,
    required this.book,
    required this.user,
  }) : super(key: key);
  
  factory Comment.fromJson(data) {
    return Comment(
      content: data['content'],
      book: Book.fromJson(data['book']),
      user: User.fromJson(data['user'])
    );
  }

  @override
  toJson() {
    return {};
  }
}
