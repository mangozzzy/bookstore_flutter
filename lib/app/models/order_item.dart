import 'package:nylo_framework/nylo_framework.dart';

class OrderItem extends Model {
  final int bookId;
  final String bookTitle;
  final int quantity;
  final double price;

  static StorageKey key = "order_item";
  
  OrderItem({
    required this.bookId,
    required this.bookTitle,
    required this.quantity,
    required this.price,
  }) : super(key: key);
  
  factory OrderItem.fromJson(data) {
    return OrderItem(
      bookId: data['bookId'],
      bookTitle: data['bookTitle'],
      quantity: data['quantity'],
      price: data['price'],
    );
  }

  @override
  toJson() {
    return {};
  }
}
