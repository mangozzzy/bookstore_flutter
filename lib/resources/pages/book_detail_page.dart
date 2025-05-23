import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/books_controller.dart';
import 'package:flutter_app/app/models/book.dart';
import 'package:flutter_app/app/models/comment.dart';
import 'package:flutter_app/app/networking/books_api_service.dart';
import 'package:flutter_app/app/networking/cart_api_service.dart';
import 'package:flutter_app/app/networking/comment_api_service.dart';
import 'package:flutter_app/app/networking/orders_api_service.dart';
import 'package:flutter_app/app/networking/rating_api_service.dart';
import 'package:gap/gap.dart';
import 'package:nylo_framework/nylo_framework.dart';

class BookDetailPage extends NyStatefulWidget {
  static RouteView path = ("/book-detail", (_) => BookDetailPage());

  BookDetailPage({super.key}) : super(child: () => _BookDetailPageState());
}

class _BookDetailPageState extends NyPage<BookDetailPage> {
  final _booksApiService = BooksApiService();
  final _cartApiService = CartApiService();
  final _ordersApiService = OrdersApiService();
  final _ratingApiService = RatingApiService();

  final _commentController = TextEditingController();
  final _booksController = BooksController();
  final _commentApiService = CommentApiService();

  late Book? _book;
  late List<Comment>? _comments;
  int _selectedRating = 0;

  @override
  get init => () async {
        _book =
            await _booksApiService.findOne(int.parse(queryParameters()['id']));
        _comments = await _commentApiService.getListByBook(
                bookId: _book?.bookId ?? 0) ??
            [];
      };

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('도서 상세정보'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBookInfo(),
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: _comments?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final item = _comments![index];

                  return ListTile(
                    title: Text(item.content ?? 'No content'),
                    subtitle: Text("${item.user?.name ?? ""}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await _commentApiService.deleteComment(
                          commentId: item.commentId ?? 0,
                        );
                        reboot();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Uncomment and use the image if needed
              // Image.network(
              //   "http://localhost:8080${_book?.imageUrl}",
              //   width: 120,
              //   height: 180,
              //   fit: BoxFit.cover,
              // ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      "http://localhost:8080${_book?.imageUrl}",
                      width: 120,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      _book?.title ?? "",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('저자: ${_book?.author}'),
                    SizedBox(height: 8),
                    Text(
                      '₩${_book?.price}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            '책 소개',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Gap(10),
          NyTextField(
            controller: _commentController,
            decoration: InputDecoration(hintText: " 댓글을 달아주세요"),
            validationRules: "not_empty",
          ),
          ElevatedButton(
            onPressed: () async {
              await _booksController.handleLogin(
                bookId: _book!.bookId,
                content: _commentController.text,
              );
              _commentController.text = "";

              reboot();
            },
            child: Text("댓글 달기"),
          ),
          SizedBox(height: 16),
          Text(
            '별점 평가',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () async {
                  _selectedRating = index + 1;
                  await _ratingApiService.create(
                    bookId: _book!.bookId,
                    score: _selectedRating,
                  );
                  reboot();
                },
                child: Icon(
                  index < _selectedRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 40,
                ),
              );
            }),
          ),
          ElevatedButton(
            onPressed: () async {
              await _cartApiService.add(bookId: _book!.bookId, quantity: 1);
            },
            child: Text("장바구니 담기"),
          ),
          ElevatedButton(
            onPressed: () async {
              final order = await _ordersApiService.create(data: {
                "items": [
                  {"bookId": _book!.bookId, "quantity": 1}
                ]
              });
              routeTo('/purchase', queryParameters: {
                "orderId": order?.id.toString(),
              });
            },
            child: Text("구매하기"),
          ),
          Gap(20),
        ],
      ),
    );
  }
}
