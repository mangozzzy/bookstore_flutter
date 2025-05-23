import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/book.dart';
import 'package:flutter_app/app/models/profile.dart';
import 'package:flutter_app/app/models/search_history.dart';
import 'package:flutter_app/app/networking/books_api_service.dart';
import 'package:flutter_app/app/networking/cart_api_service.dart';
import 'package:flutter_app/app/networking/profile_api_service.dart';
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
  final _cartApiService = CartApiService();
  final _searchHistoryApiService = SearchHistoryApiService();
  final _searchFocusNode = FocusNode();
  final _searchController = TextEditingController();
  final _profileApiSerivce = ProfileApiService();

  late List<Book>? _books;
  late List<Book>? _filteredBooks;
  late List<SearchHistory>? _searchHistories;
  late Profile? _profile;
  bool _isSearchFocused = false;

  String _searchQuery = '';
  String _sortCriteria = 'title';
  bool _isAscending = true; // 並び替えの方向を管理

  final List<String> _genres = [
    '동화',
    '고전',
    '전후소설',
    '풍자',
    '디스토피아'
  ];
  Set<String> _selectedGenres = {};

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
    _profile = await _profileApiSerivce.getProfile();
    if (_profile == null) {
      return routeTo('/login');
    }
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

  void _filterByGenres() {
    setState(() {
      if (_selectedGenres.isEmpty) {
        _filteredBooks = _books;
      } else {
        _filteredBooks = _books?.where((book) {
          return _selectedGenres.any((genre) => book.genre?.contains(genre) ?? false);
        }).toList();
      }
    });
  }

  void _toggleGenre(String genre) {
    setState(() {
      if (_selectedGenres.contains(genre)) {
        _selectedGenres.remove(genre);
      } else {
        _selectedGenres.add(genre);
      }
      _filterByGenres();
    });
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onSubmitted: (value) {
            _filterBooks(value);
            if (value.isNotEmpty) {
              _searchHistoryApiService.create(keyword: value);
              setState(() {
                _searchHistories?.add(SearchHistory(keyword: value));
              });
            }
            _searchFocusNode.unfocus();
          },
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: _genres.map((genre) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(genre),
                      selected: _selectedGenres.contains(genre),
                      onSelected: (bool selected) {
                        _toggleGenre(genre);
                      },
                    ),
                  );
                }).toList(),
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
                                    Row(children: [
                                      Text(
                                        book.title ?? "",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(" (${book.commentCount})"),
                                    ],),
                                    Text(
                                      book.author ?? "",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      '₩${book.price}',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: List.generate(5, (index) {
                                            return Icon(
                                              index < review ? Icons.star : Icons.star_border,
                                              color: Colors.amber,
                                              size: 16,
                                            );
                                          }),
                                        ),
                                        Text('(${review.toStringAsFixed(1)})'),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    ElevatedButton(
                                      onPressed: () async {
                                        showToast(
                                          title: "성공",
                                          description: "장바구니에 추가되었습니다.",
                                        );
                                        await _cartApiService.add( bookId: book.bookId, quantity: 1);
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
