import 'package:nylo_framework/nylo_framework.dart';

class Payment extends Model {
  final int id;
  final String paymentMethod;
  final String paymentDate;
  final bool paid;

  static StorageKey key = "payment";

  Payment({
    required this.id,
    required this.paymentMethod,
    required this.paymentDate,
    required this.paid,
  }) : super(key: key);

  factory Payment.fromJson(data) {
    return Payment(
      id: data['id'],
      paymentMethod: data['paymentMethod'],
      paymentDate: data['paymentDate'],
      paid: data['paid'],
    );
  }

  @override
  toJson() {
    return {};
  }
}
