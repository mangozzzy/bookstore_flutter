import 'package:flutter_app/app/models/item.dart';
import 'package:nylo_framework/nylo_framework.dart';

class Cart extends Model {
  final int id;
  final List<Item> items;

  static StorageKey key = "cart";
  
  Cart({
      required this.id,
      required this.items,
    }) : super(key: key);
  
  factory Cart.fromJson(data) {
    return Cart(
      id: data['id'],
      items: List.from(data['items']).map((json) => Item.fromJson(json)).toList(),
    );
  }

  @override
  toJson() {
    return {};
  }
}
