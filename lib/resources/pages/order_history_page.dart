import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class OrderHistoryPage extends NyStatefulWidget {
  static RouteView path = ("/order-history", (_) => OrderHistoryPage());
  
  OrderHistoryPage({super.key}) : super(child: () => _OrderHistoryPageState());
}

class _OrderHistoryPageState extends NyState<OrderHistoryPage> {
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
              Tab(text: '배송현황'),
              Tab(text: '구매완료'),
              Tab(text: '환불/교환'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _DeliveryStatusTab(),
            _CompletedOrdersTab(),
            _RefundExchangeTab(),
          ],
        ),
      ),
    );
  }
}

class _DeliveryStatusTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // 예시 데이터
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('주문번호: ORDER-2024-${1000 + index}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('플러터 입문 외 2권'),
                Text('배송상태: 배송중'),
                Text('예상 도착일: 2024-03-${20 + index}'),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                // 배송 추적 페이지로 이동
              },
              child: Text('배송조회'),
            ),
          ),
        );
      },
    );
  }
}

class _CompletedOrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('주문번호: ORDER-2024-${900 + index}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('도서명: 플러터 입문'),
                Text('구매일자: 2024-02-${10 + index}'),
                Text('결제금액: ₩30,000'),
              ],
            ),
            trailing: TextButton(
              onPressed: () {
                // 리뷰 작성 페이지로 이동
              },
              child: Text('리뷰작성'),
            ),
          ),
        );
      },
    );
  }
}

class _RefundExchangeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('주문번호: ORDER-2024-${800 + index}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('도서명: 플러터 입문'),
                Text('신청일자: 2024-03-${5 + index}'),
                Text('처리상태: 처리중'),
              ],
            ),
            trailing: TextButton(
              onPressed: () {
                // 환불/교환 상세 페이지로 이동
              },
              child: Text('상세보기'),
            ),
          ),
        );
      },
    );
  }
} 