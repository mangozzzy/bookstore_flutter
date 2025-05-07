import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/profile.dart';
import 'package:flutter_app/app/networking/payment_api_service.dart';
import 'package:flutter_app/app/networking/profile_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

class PurchasePage extends NyStatefulWidget {
  static RouteView path = ("/purchase", (_) => PurchasePage());

  PurchasePage({super.key}) : super(child: () => _PurchasePageState());
}

class _PurchasePageState extends NyState<PurchasePage> {
  String _selectedPayment = '카드';
  final List<String> _paymentMethods = ['신한', '농협', '삼성'];
  String? _selectedCoupon;
  final List<String> _availableCoupons = ['신규 가입 10% 할인', '도서 특별 20% 할인'];
  late Profile? _profile;

  final _paymentApiService = PaymentApiService();
  final _profileApiService = ProfileApiService();
  final _addressController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();


  @override
  get init => () async {
    _profile = await _profileApiService.getProfile();
    _addressController.text = _profile?.address ?? "";
  };

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문/결제'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPaymentMethodSection(),
              Divider(height: 32),
              _buildCouponSection(),
              Divider(height: 32),
              _buildDeliverySection(),
              Divider(height: 32),
              _buildOrderSummary(),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handlePurchase,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('결제하기', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('결제 카드 선택',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        ...List.generate(_paymentMethods.length, (index) {
          return RadioListTile<String>(
            title: Text(_paymentMethods[index]),
            value: _paymentMethods[index],
            groupValue: _selectedPayment,
            onChanged: (value) {
              setState(() => _selectedPayment = value!);
            },
          );
        }),
        TextFormField(
          //controller: _addressController,
          decoration: InputDecoration(
            labelText: '카드번호 입력',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // 주소 검색 기능
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCouponSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('쿠폰 적용',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '사용 가능한 쿠폰 선택',
          ),
          value: _selectedCoupon,
          items: _availableCoupons.map((coupon) {
            return DropdownMenuItem(
              value: coupon,
              child: Text(coupon),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedCoupon = value);
          },
        ),
      ],
    );
  }

  Widget _buildDeliverySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('배송 정보',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: '배송지 주소',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // 주소 검색 기능
              },
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return '배송지를 입력해주세요';
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        Text(
          '예상 배송일: ${_getEstimatedDeliveryDate()}',
          style: TextStyle(color: Colors.blue),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    final originalPrice = 30000;
    final discountAmount = _selectedCoupon != null
        ? (_selectedCoupon!.contains('20%')
            ? originalPrice * 0.2
            : originalPrice * 0.1)
        : 0;
    final finalPrice = originalPrice - discountAmount;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('주문 내역',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('상품 금액'),
                Text('₩${originalPrice.toStringAsFixed(0)}'),
              ],
            ),
            if (_selectedCoupon != null) ...[
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('할인 금액'),
                  Text('-₩${discountAmount.toStringAsFixed(0)}'),
                ],
              ),
            ],
            Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('최종 결제 금액', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '₩${finalPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getEstimatedDeliveryDate() {
    final now = DateTime.now();
    final deliveryDate = now.add(Duration(days: 3));
    return '${deliveryDate.year}-${deliveryDate.month.toString().padLeft(2, '0')}-${deliveryDate.day.toString().padLeft(2, '0')}';
  }

  Future<void> _handlePurchase() async {
    await _paymentApiService.payProcess(
        orderId: int.parse(queryParameters()['orderId']), method: "카드");

    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('결제 확인'),
          content: Text('선택하신 결제 수단으로 결제를 진행하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showToast(
                  title: "성공",
                  description: "결제가 완료되었습니다.",
                );
                Navigator.pushReplacementNamed(context, '/order-history');
              },
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
  }
}
