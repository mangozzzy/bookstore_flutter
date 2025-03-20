import 'package:nylo_framework/nylo_framework.dart';

class OrderDelivery extends Model {

  static StorageKey key = "order_delivery";
  
  OrderDelivery() : super(key: key);
  
  OrderDelivery.fromJson(data) {

  }

  @override
  toJson() {
    return {};
  }
}
