import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/order.dart';
import 'package:flutter_app/app/networking/orders_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

class OrderHistoryPage extends NyStatefulWidget {
  static RouteView path = ("/order-history", (_) => OrderHistoryPage());

  OrderHistoryPage({super.key}) : super(child: () => _OrderHistoryPageState());
}

class _OrderHistoryPageState extends NyState<OrderHistoryPage> {
  late List<Order> orders;

  final _ordersApiService = OrdersApiService();

  @override
  get init => () async {
        orders = await _ordersApiService.findAll() ?? [];
      };

  @override
  Widget view(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('구매내역 관리'),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text("id: ${order.id}"),
                  subtitle: Text(
                      "title: ${order.orderItems.map((e) => e.bookTitle.toString()).join(', ')}, status: ${order.status}"),
                );
              },
            ),
            // 他のタブのウィジェットをここに追加
            Container(), // 購入完了タブのためのプレースホルダー
            Container(), // 환불/교환タブのためのプレースホルダー
          ],
        ),
      ),
    );
  }
}
