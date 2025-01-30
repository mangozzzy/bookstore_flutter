import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

import 'profile_page.dart';
import 'book_detail_page.dart';

class HomePage extends NyStatefulWidget {
  static RouteView path = ("/home", (_) => HomePage());
  
  HomePage({super.key}) : super(child: () => _HomePageState());
}

class _HomePageState extends NyPage<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          BookStorePage(),  // 도서 쇼핑몰 페이지
          ProfilePage(),    // 프로필 페이지
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '도서몰',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내정보',
          ),
        ],
      ),
    );
  }
}

// 도서 쇼핑몰 페이지
class BookStorePage extends NyStatefulWidget {
  BookStorePage({super.key}) : super(child: () => _BookStorePageState());
}

class _BookStorePageState extends NyState<BookStorePage> {
  final List<Book> books = [
    Book(
      id: '1',
      title: '물과꿈',
      author: '플러터',
      price: 30000,
      imageUrl: 'https://i.pinimg.com/736x/b5/b7/22/b5b72237429a207b589e221de7c947fb.jpg',
      description: '플러터 입문자를 위한 완벽 가이드. 기초부터 실전까지 모든 내용을 담았습니다.',
      publishedYear: 2024,
      rating: 4.5,
      commentCount: 128,
      publisher: '코딩출판사',
      genres: ['교육', '기술', '자기계발'],
    ),
    Book(
      id: '2',
      title: '코틀린 프로그래밍',
      author: '이코틀린',
      price: 28000,
      imageUrl: 'https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9788936434595.jpg',
      description: '안드로이드 개발을 위한 코틀린 완벽 가이드',
      publishedYear: 2023,
      rating: 4.8,
      commentCount: 95,
      publisher: '코딩출판사',
      genres: ['교육', '기술', '취미'],
    ),
    Book(
      id: '3',
      title: '스위프트 기초',
      author: '박스위프트',
      price: 32000,
      imageUrl: 'https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9791198853943.jpg',
      description: 'iOS 개발을 시작하는 분들을 위한 스위프트 기초 교재',
      publishedYear: 2024,
      rating: 4.3,
      commentCount: 67,
      publisher: '코딩출판사',
      genres: ['교육', '기술', '과학'],
    ),
    Book(
      id: '4',
      title: '파이썬 알고리즘',
      author: '정파이썬',
      price: 25000,
      imageUrl: 'https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9791130662596.jpg',
      description: '코딩 테스트를 위한 파이썬 알고리즘 문제 해결 전략',
      publishedYear: 2023,
      rating: 4.7,
      commentCount: 156,
      publisher: '코딩출판사',
      genres: ['교육', '기술', '과학', '자기계발'],
    ),
    Book(
      id: '5',
      title: '자바스크립트 마스터',
      author: '최자바',
      price: 35000,
      imageUrl: 'https://contents.kyobobook.co.kr/sih/fit-in/458x0/pdt/9791141608774.jpg',
      description: '현대적인 자바스크립트 프로그래밍을 위한 완벽 가이드',
      publishedYear: 2024,
      rating: 4.6,
      commentCount: 142,
      publisher: '코딩출판사',
      genres: ['교육', '기술', '자기계발'],
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  List<String> searchHistory = [];
  List<String> autoCompleteResults = [];
  bool showAdvancedSearch = false;
  
  // 고급 검색을 위한 컨트롤러들
  final TextEditingController _advancedTitleController = TextEditingController();
  final TextEditingController _advancedAuthorController = TextEditingController();
  final TextEditingController _advancedPublisherController = TextEditingController();
  String searchType = '제목'; // 검색 타입 (제목/작가명/출판사명)
  List<Book> filteredBooks = [];
  String sortType = '댓글순';
  bool isAscending = false;
  Set<String> selectedGenres = {};

  @override
  void initState() {
    super.initState();
    filteredBooks = List.from(books);
  }

  void _sortBooks() {
    switch (sortType) {
      case '댓글순':
        filteredBooks.sort((a, b) => isAscending 
          ? a.commentCount.compareTo(b.commentCount)
          : b.commentCount.compareTo(a.commentCount));
        break;
      case '가나다순':
        filteredBooks.sort((a, b) => isAscending 
          ? a.title.compareTo(b.title)
          : b.title.compareTo(a.title));
        break;
      case '별점순':
        filteredBooks.sort((a, b) => isAscending 
          ? a.rating.compareTo(b.rating)
          : b.rating.compareTo(a.rating));
        break;
    }
  }

  void _filterBooks(String query) {
    filteredBooks = books.where((book) {
      bool matchesSearch = true;
      if (query.isNotEmpty) {
        switch (searchType) {
          case '제목':
            matchesSearch = book.title.toLowerCase().contains(query.toLowerCase());
            break;
          case '작가명':
            matchesSearch = book.author.toLowerCase().contains(query.toLowerCase());
            break;
          case '출판사명':
            matchesSearch = book.publisher.toLowerCase().contains(query.toLowerCase());
            break;
        }
      }
      
      bool matchesGenres = selectedGenres.isEmpty || 
        selectedGenres.every((genre) => book.genres.contains(genre));
      
      return matchesSearch && matchesGenres;
    }).toList();
    
    _sortBooks();
    setState(() {});
  }

  void _handleSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        autoCompleteResults = [];
        filteredBooks = List.from(books);
      });
      return;
    }

    // 자동완성 결과 업데이트
    setState(() {
      autoCompleteResults = books
          .where((book) {
            final searchField = searchType == '제목' 
                ? book.title 
                : searchType == '작가명' 
                    ? book.author 
                    : book.publisher;
            return searchField.toLowerCase().contains(query.toLowerCase());
          })
          .map((book) => searchType == '제목' 
              ? book.title 
              : searchType == '작가명' 
                  ? book.author 
                  : book.publisher)
          .toSet()
          .toList();
    });

    _filterBooks(query);
  }

  void _addToSearchHistory(String query) {
    if (query.isNotEmpty && !searchHistory.contains(query)) {
      setState(() {
        searchHistory.insert(0, query);
        // 최대 10개까지만 저장
        if (searchHistory.length > 10) {
          searchHistory.removeLast();
        }
      });
    }
  }

  void _advancedSearch() {
    filteredBooks = books.where((book) {
      bool matchesTitle = _advancedTitleController.text.isEmpty ||
          book.title.toLowerCase().contains(_advancedTitleController.text.toLowerCase());
      
      bool matchesAuthor = _advancedAuthorController.text.isEmpty ||
          book.author.toLowerCase().contains(_advancedAuthorController.text.toLowerCase());
      
      bool matchesPublisher = _advancedPublisherController.text.isEmpty ||
          book.publisher.toLowerCase().contains(_advancedPublisherController.text.toLowerCase());
      
      return matchesTitle && matchesAuthor && matchesPublisher;
    }).toList();

    _sortBooks();
    setState(() {});
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('도서몰'),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              // 장바구니 아이템 개수 표시 (상태관리 필요)
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // 기본 검색바
                if (!showAdvancedSearch)
                  Column(
                    children: [
                      SearchBar(
                        controller: _searchController,
                        leading: DropdownButton<String>(
                          value: searchType,
                          items: ['제목', '작가명', '출판사명']
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              searchType = value!;
                              _handleSearch(_searchController.text);
                            });
                          },
                        ),
                        trailing: [
                          IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _handleSearch('');
                            },
                          ),
                        ],
                        onChanged: _handleSearch,
                        onSubmitted: (query) {
                          _addToSearchHistory(query);
                          autoCompleteResults = [];
                        },
                      ),

                      // 검색어 입력 시 자동완성과 검색 기록 표시
                      if (_searchController.text.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 자동완성 결과
                              if (autoCompleteResults.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('추천 검색어',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                ...autoCompleteResults.map((result) => ListTile(
                                  title: Text(result),
                                  onTap: () {
                                    _searchController.text = result;
                                    _addToSearchHistory(result);
                                    _handleSearch(result);
                                    setState(() {
                                      autoCompleteResults = [];
                                    });
                                  },
                                )).toList(),
                                Divider(),
                              ],

                              // 검색 기록
                              if (searchHistory.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('최근 검색어',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            searchHistory.clear();
                                          });
                                        },
                                        child: Text('전체 삭제',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...searchHistory.map((term) => ListTile(
                                  title: Text(term),
                                  trailing: IconButton(
                                    icon: Icon(Icons.close, size: 16),
                                    onPressed: () {
                                      setState(() {
                                        searchHistory.remove(term);
                                      });
                                    },
                                  ),
                                  onTap: () {
                                    _searchController.text = term;
                                    _handleSearch(term);
                                  },
                                )).toList(),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),

                // 고급 검색
                if (showAdvancedSearch)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _advancedTitleController,
                            decoration: InputDecoration(
                              labelText: '제목',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: _advancedAuthorController,
                            decoration: InputDecoration(
                              labelText: '작가',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: _advancedPublisherController,
                            decoration: InputDecoration(
                              labelText: '출판사',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _advancedSearch,
                            child: Text('검색'),
                          ),
                        ],
                      ),
                    ),
                  ),

                // 검색 모드 전환 버튼
                TextButton(
                  onPressed: () {
                    setState(() {
                      showAdvancedSearch = !showAdvancedSearch;
                      if (!showAdvancedSearch) {
                        _advancedTitleController.clear();
                        _advancedAuthorController.clear();
                        _advancedPublisherController.clear();
                        filteredBooks = List.from(books);
                      }
                    });
                  },
                  child: Text(showAdvancedSearch ? '기본 검색으로 전환' : '고급 검색으로 전환'),
                ),

                // 정렬 옵션
                Row(
                  children: [
                    DropdownButton<String>(
                      value: sortType,
                      items: ['댓글순', '가나다순', '별점순']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          sortType = value!;
                          _sortBooks();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                      onPressed: () {
                        setState(() {
                          isAscending = !isAscending;
                          _sortBooks();
                        });
                      },
                    ),
                  ],
                ),

                // 장르 필터
                Wrap(
                  spacing: 8,
                  children: [
                    '교육', '기술', '소설', '시', '에세이', 
                    '자기계발', '경제', '역사', '과학', '예술',
                    '인문', '철학', '종교', '취미', '요리'
                  ].map((genre) {
                    return FilterChip(
                      label: Text(genre),
                      selected: selectedGenres.contains(genre),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedGenres.add(genre);
                          } else {
                            selectedGenres.remove(genre);
                          }
                          _filterBooks(_searchController.text);
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
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
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final book = filteredBooks[index];
                return GestureDetector(
                  onTap: () {
                    routeTo("/book-detail");
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(
                            book.imageUrl,
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
                                book.title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                book.author,
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                '₩${book.price.toStringAsFixed(0)}',
                                style: TextStyle(color: Colors.blue),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                  Text(' ${book.rating}'),
                                  Text(' (${book.commentCount})'),
                                ],
                              ),
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
            ),
          ),
        ],
      ),
    );
  }
}

class Book {
  final String id;
  final String title;
  final String author;
  final double price;
  final String imageUrl;
  final String description;
  final int publishedYear;
  final double rating;
  final int commentCount;
  final String publisher;
  final List<String> genres;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.publishedYear,
    required this.rating,
    required this.commentCount,
    required this.publisher,
    required this.genres,
  });
}
