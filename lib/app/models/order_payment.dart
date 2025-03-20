import 'package:nylo_framework/nylo_framework.dart';

class OrderPayment extends Model {

  static StorageKey key = "order_payment";
  
  OrderPayment() : super(key: key);
  
  OrderPayment.fromJson(data) {

  }

  @override
  toJson() {
    return {};
  }
}
