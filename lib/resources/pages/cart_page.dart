import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/cart.dart';
import 'package:flutter_app/app/networking/cart_api_service.dart';
import 'package:flutter_app/app/networking/orders_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

class CartPage extends NyStatefulWidget {
  static RouteView path = ("/cart", (_) => CartPage());

  CartPage({super.key}) : super(child: () => _CartPageState());
}

class _CartPageState extends NyPage<CartPage> {
  late Cart? _cart;

  final _cartApiService = CartApiService();
  final _ordersApiService = OrdersApiService();

  @override
  get init => () async {
        _cart = await _cartApiService.getItems();
      };

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장바구니'),
        centerTitle: true,
      ),
      body: _cart!.items.isEmpty
          ? Center(child: Text('장바구니가 비어있습니다'))
          : ListView.builder(
              itemCount: _cart!.items.length,
              itemBuilder: (context, index) {
                final item = _cart!.items[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      item.book.imageUrl ?? "",
                      width: 50,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.book, size: 50),
                    ),
                    title: Text(item.book.title ?? ""),
                    subtitle: Text('₩${item.book.price?.toStringAsFixed(0)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => _updateQuantity(index, -1),
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => _updateQuantity(index, 1),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _removeItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: _cart!.items.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('총 금액:', style: TextStyle(fontSize: 18)),
                        Text(
                          '₩${_calculateTotal().toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final order = await _ordersApiService.create(data: {
                          "items": _cart!.items.map((item) => {
                            "bookId": item.book.bookId,
                            "quantity": item.quantity
                          }).toList()
                        });

                        routeTo('/purchase', queryParameters: {
                          "orderId": order?.id.toString() ?? "",
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text('구매하기', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      //_cart!.items[index].quantity += change;
      if (_cart!.items[index].quantity < 1) {
        _cart!.items.removeAt(index);
      }
    });
  }

  void _removeItem(int index) async {
    final item = _cart!.items[index];
    final updatedCart = await _cartApiService.remove(bookId: item.book.bookId);
    reboot();
  }

  double _calculateTotal() {
    return _cart!.items
        .fold(0, (sum, item) => sum + (item.book.price ?? 0 * item.quantity));
  }

  void _handleCheckout() {
    // 구매 처리 로직
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('구매 확인'),
        content: Text('총 ${_calculateTotal().toStringAsFixed(0)}원을 결제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              // 결제 처리 로직
              Navigator.pop(context);
              showToast(
                title: "성공",
                description: "구매가 완료되었습니다.",
              );
              setState(() {
                _cart!.items.clear();
              });
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

