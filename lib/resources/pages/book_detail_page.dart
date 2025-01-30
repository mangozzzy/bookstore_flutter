import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart' show NyState, NyStatefulWidget, RouteView, getRouteData;

class BookDetailPage extends NyStatefulWidget {
  static RouteView path = ("/book-detail", (_) => BookDetailPage());
  
  BookDetailPage({super.key}) : super(child: () => _BookDetailPageState());
}

class _BookDetailPageState extends NyState<BookDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> comments = []; // 실제 구현시 서버에서 데이터 가져오기

  @override
  void initState() {
    super.initState();
    // 예시 댓글 데이터
    comments = [
      Comment(
        id: '1',
        userId: 'user1',
        content: '정말 좋은 책이에요!',
        createdAt: DateTime.now().subtract(Duration(days: 1)),
      ),
      Comment(
        id: '2',
        userId: 'user2',
        content: '초보자도 이해하기 쉽게 설명되어 있습니다.',
        createdAt: DateTime.now().subtract(Duration(days: 2)),
      ),
    ];
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('도서 상세정보'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBookInfo(),
            Divider(height: 1),
            _buildActionButtons(),
            Divider(height: 1),
            _buildCommentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
"https://i.pinimg.com/736x/b5/b7/22/b5b72237429a207b589e221de7c947fb.jpg",
                width: 120,
                height: 180,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "채식주의자",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('저자: ${"한강"}'),
                    Text('출판: ${2022}년'),
                    SizedBox(height: 8),
                    Text(
                      '₩${50000.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        Text(' ${4.5.toStringAsFixed(1)}'),
                        Text(' (${comments.length}개의 리뷰)'),
                      ],
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
          SizedBox(height: 8),
          Text("book1"),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // 구매 페이지로 이동
                Navigator.pushNamed(context, '/cart');
              },
              child: Text('구매하기'),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // 장바구니에 추가
                showToast(
                  title: "성공",
                  description: "장바구니에 추가되었습니다.",
                );
              },
              child: Text('장바구니'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '댓글',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: '댓글을 입력하세요',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: _addComment,
              ),
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return Card(
                child: ListTile(
                  title: Text(comment.content),
                  subtitle: Text(
                    '${comment.userId} • ${_formatDate(comment.createdAt)}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteComment(index),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        comments.insert(
          0,
          Comment(
            id: DateTime.now().toString(),
            userId: 'currentUser', // 실제 구현시 현재 로그인한 사용자 ID
            content: _commentController.text,
            createdAt: DateTime.now(),
          ),
        );
        _commentController.clear();
      });
    }
  }

  void _deleteComment(int index) {
    setState(() {
      comments.removeAt(index);
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class Comment {
  final String id;
  final String userId;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
  });
} 