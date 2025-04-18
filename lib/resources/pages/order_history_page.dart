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

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return '주문완료';
      case 'processing':
        return '처리중';
      case 'cancelled':
        return '취소됨';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'processing':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget view(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('구매내역 관리'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: '전체'),
              Tab(text: '주문완료'),
              Tab(text: '환불/교환'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '주문번호: ${order.id}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.status),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getStatusText("주문완료"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '주문한 도서:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...order.orderItems.map((item) => Padding(
                              padding: EdgeInsets.only(left: 8, top: 4),
                              child: Text(
                                '• ${item.bookTitle}',
                                style: TextStyle(fontSize: 14),
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(), // 주문완료 탭
            Container(), // 환불/교환 탭
          ],
        ),
      ),
    );
  }
}
