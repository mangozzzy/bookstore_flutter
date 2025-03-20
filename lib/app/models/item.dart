import 'package:flutter_app/app/models/book.dart';
import 'package:nylo_framework/nylo_framework.dart';

class Item extends Model {
  final int id;
  final int quantity;
  final Book book;

  static StorageKey key = "item";

  Item({
    required this.id,
    required this.quantity,
    required this.book,
  }) : super(key: key);

  factory Item.fromJson(data) {
    return Item(
      id: data['id'],
      quantity: data['quantity'],
      book: Book.fromJson(data['book']),
    );
  }

  @override
  toJson() {
    return {};
  }
}
