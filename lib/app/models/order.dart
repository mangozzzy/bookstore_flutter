import 'package:flutter_app/app/models/order_delivery.dart';
import 'package:flutter_app/app/models/order_item.dart';
import 'package:flutter_app/app/models/order_payment.dart';
import 'package:nylo_framework/nylo_framework.dart';

class Order extends Model {
  final int id;
  final List<OrderItem> orderItems;
  final OrderPayment payment;
  final OrderDelivery delivery;
  final String orderDate;
  final String status;
  final double totalAmount;
  final double discountedAmount;
  final String? address;

  static StorageKey key = "order";

  Order(
      {required this.id,
      required this.orderItems,
      required this.payment,
      required this.delivery,
      required this.orderDate,
      required this.status,
      required this.totalAmount,
      required this.discountedAmount,
      required this.address})
      : super(key: key);

  factory Order.fromJson(data) {
    return Order(
        id: data['id'],
        orderItems: data['orderItems']
            .map<OrderItem>((item) => OrderItem.fromJson(item))
            .toList(),
        payment: OrderPayment.fromJson(data['payment']),
        delivery: OrderDelivery.fromJson(data['delivery']),
        orderDate: data['orderDate'],
        status: data['status'],
        totalAmount: data['totalAmount'],
        discountedAmount: data['discountedAmount'],
        address: data['address']);
  }

  @override
  toJson() {
    return {};
  }
}
