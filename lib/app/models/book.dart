import 'package:nylo_framework/nylo_framework.dart';

class Book extends Model {
  final int bookId;
  final String? title;
  final String? author;
  final String? publisher;
  final String? genre;
  final double? price;
  final String? imageUrl;
  final int? commentCount;
  final String? createdAt;
  final String? updatedAt;

  static StorageKey key = "book";
  
  Book({
    required this.bookId,
    this.title,
    this.author,
    this.publisher,
    this.genre,
    this.price,
    this.imageUrl,
    this.commentCount,
    this.createdAt,
    this.updatedAt,
  }) : super(key: key);
  
  factory Book.fromJson(dynamic data) {
    return Book(
      bookId: data['bookId'],
      title: data['title'],
      author: data['author'],
      publisher: data['publisher'],
      genre: data['genre'],
      price: data['price'],
      imageUrl: data['imageUrl'],
      commentCount: data['commentCount'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );   
  }

  @override
  toJson() {
    return {};
  }
}
