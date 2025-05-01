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
  late List<Order> refundOrders;

  final _ordersApiService = OrdersApiService();

  @override
  get init => () async {
        orders = await _ordersApiService.findAll() ?? [];
        refundOrders = [];
      };

  void _handleRefund(Order order) {
    setState(() {
      orders.remove(order);
      final updatedOrder = Order(
        id: order.id,
        orderItems: order.orderItems,
        payment: order.payment,
        delivery: order.delivery,
        orderDate: order.orderDate,
        status: 'refund_requested',
        totalAmount: order.totalAmount,
        discountedAmount: order.discountedAmount,
        address: order.address,
      );
      refundOrders.add(updatedOrder);
    });
  }

  void _handleExchange(Order order) {
    setState(() {
      orders.remove(order);
      final updatedOrder = Order(
        id: order.id,
        orderItems: order.orderItems,
        payment: order.payment,
        delivery: order.delivery,
        orderDate: order.orderDate,
        status: 'exchange_requested',
        totalAmount: order.totalAmount,
        discountedAmount: order.discountedAmount,
        address: order.address,
      );
      refundOrders.add(updatedOrder);
    });
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return '주문완료';
      case 'processing':
        return '처리중';
      case 'cancelled':
        return '취소됨';
      case 'refund_requested':
        return '환불요청';
      case 'exchange_requested':
        return '교환요청';
      default:
        return "주문완료";
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
      case 'refund_requested':
      case 'exchange_requested':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildOrderList(List<Order> orderList, {bool showActionButtons = true}) {
    return ListView.builder(
      itemCount: orderList.length,
      itemBuilder: (context, index) {
        final order = orderList[index];
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
                        _getStatusText(order.status),
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
                if (showActionButtons) ...[
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => _handleRefund(order),
                        child: Text("환불"),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _handleExchange(order),
                        child: Text("교환"),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget view(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('구매내역 관리'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: '주문완료'),
              Tab(text: '환불/교환'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList(orders),
            _buildOrderList(refundOrders, showActionButtons: false),
          ],
        ),
      ),
    );
  }
}
