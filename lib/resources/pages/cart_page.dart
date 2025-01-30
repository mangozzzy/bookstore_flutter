import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class CartPage extends NyStatefulWidget {
  static RouteView path = ("/cart", (_) => CartPage());
  
  CartPage({super.key}) : super(child: () => _CartPageState());
}

class _CartPageState extends NyPage<CartPage> {
  List<CartItem> cartItems = []; // 실제 구현시 상태관리로 변경 필요

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('장바구니'),
        centerTitle: true,
      ),
      body: cartItems.isEmpty 
          ? Center(child: Text('장바구니가 비어있습니다'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      item.imageUrl,
                      width: 50,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.book, size: 50),
                    ),
                    title: Text(item.title),
                    subtitle: Text('₩${item.price.toStringAsFixed(0)}'),
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
      bottomNavigationBar: cartItems.isEmpty 
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
                      onPressed: _handleCheckout,
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
      cartItems[index].quantity += change;
      if (cartItems[index].quantity < 1) {
        cartItems.removeAt(index);
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  double _calculateTotal() {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
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
                cartItems.clear();
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