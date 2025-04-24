import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/book.dart';
import 'package:flutter_app/app/models/search_history.dart';
import 'package:flutter_app/app/networking/books_api_service.dart';
import 'package:flutter_app/app/networking/rating_api_service.dart';
import 'package:flutter_app/app/networking/search_history_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

class Books extends StatefulWidget {
  const Books({super.key});

  @override
  createState() => _BooksState();
}

class _BooksState extends NyState<Books> {
  final _booksApiService = BooksApiService();
  final _ratingApiService = RatingApiService();
  final _searchHistoryApiService = SearchHistoryApiService();
  final _searchFocusNode = FocusNode();
  final _searchController = TextEditingController();

  late List<Book>? _books;
  late List<Book>? _filteredBooks;
  late List<SearchHistory>? _searchHistories;
  bool _isSearchFocused = false;

  String _searchQuery = '';
  String _sortCriteria = 'title';
  bool _isAscending = true; // 並び替えの方向を管理

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });

  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  get init => () async {
    _books = await _booksApiService.findAll();
    _filteredBooks = _books;
    _searchHistories = await _searchHistoryApiService.findAll();
  };

  void _filterBooks(String query) {
    setState(() {
      _searchQuery = query;
      _filteredBooks = _books?.where((book) {
        return book.title!.toLowerCase().contains(query.toLowerCase()) ||
            book.author!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _sortBooks(String criteria) {
    setState(() {
      _sortCriteria = criteria;
      _filteredBooks?.sort((a, b) {
        int comparison;
        switch (criteria) {
          case 'title':
            comparison = a.title!.compareTo(b.title!);
            break;
          case 'author':
            comparison = a.author!.compareTo(b.author!);
            break;
          case 'commentCount':
            comparison = (a.commentCount ?? 0).compareTo(b.commentCount ?? 0);
            break;
          case 'review':
            comparison = (a.averageRating ?? 0).compareTo(b.averageRating ?? 0);
            break;
          default:
            comparison = 0;
        }
        return _isAscending ? comparison : -comparison; // 昇順または降順を適用
      });
    });
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: _filterBooks,
          decoration: InputDecoration(
            hintText: '검색어를 입력하세요',
            border: InputBorder.none,
          ),
        ),
        centerTitle: true,
        actions: [
          DropdownButton<String>(
            value: _sortCriteria,
            items: [
              DropdownMenuItem(value: 'title', child: Text('책 제목')),
              DropdownMenuItem(value: 'author', child: Text('작가명')),
              DropdownMenuItem(value: 'commentCount', child: Text('리뷰 많은 순')),
              DropdownMenuItem(value: 'review', child: Text('평점 높은 순')),
            ],
            onChanged: (value) {
              if (value != null) {
                _sortBooks(value);
              }
            },
          ),
          IconButton(
            icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                _isAscending = !_isAscending; // 並び替えの方向を切り替え
                _sortBooks(_sortCriteria); // 並び替えを再適用
              });
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (_searchFocusNode.hasFocus) {
            _searchFocusNode.unfocus();
          }
        },
        child: Column(
          children: [
            if (_isSearchFocused)
              Container(
                height: (_searchHistories?.length ?? 0) * 56.0,
                child: ListView.builder(
                  itemCount: _searchHistories?.length ?? 0,
                  itemBuilder: (context, index) {
                    final history = _searchHistories![index];
                    return ListTile(
                      title: Text(history.keyword ?? ''),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.grey),
                        onPressed: () async {
                          await _searchHistoryApiService.destroy(keyword: history.keyword ?? '');
                          setState(() {
                            _searchHistories = _searchHistories?.where((h) => h.keyword != history.keyword).toList();
                          });
                        },
                      ),
                      onTap: () {
                        _searchController.text = history.keyword ?? "";
                        _filterBooks(history.keyword ?? '');
                        setState(() {
                          _searchQuery = history.keyword ?? "";
                          _isSearchFocused = false;
                        });
                      },
                    );
                  },
                ),
              ),

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _filteredBooks?.length ?? 0,
                itemBuilder: (context, index) {
                  final book = _filteredBooks![index];
                  return FutureBuilder<double>(
                    future: _ratingApiService.getAverage(bookId: book.bookId),
                    builder: (context, snapshot) {
                      final review = snapshot.data ?? 0;
                      return GestureDetector(
                        onTap: () {
                          routeTo("/book-detail", queryParameters: {"id": book.bookId.toString()});
                        },
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  "${getEnv("API_BASE_URL")}${book.imageUrl}",
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.title ?? "",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      book.author ?? "",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      '₩${book.price}',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Text("comment: ${book.commentCount}"),
                                    Text("Review: ${review}"),
                                    SizedBox(height: 4),
                                    ElevatedButton(
                                      onPressed: () {
                                        showToast(
                                          title: "성공",
                                          description: "장바구니에 추가되었습니다.",
                                        );
                                      },
                                      child: Text('장바구니 담기'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
