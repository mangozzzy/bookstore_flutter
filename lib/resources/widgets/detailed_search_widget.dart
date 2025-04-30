import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/book.dart';
import 'package:flutter_app/app/networking/books_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

class DetailedSearch extends StatefulWidget {
  const DetailedSearch({super.key});

  @override
  createState() => _DetailedSearchState();
}

class _DetailedSearchState extends NyState<DetailedSearch> {
  late List<Book>? _books;
  late List<Book>? _filteredBooks;
  final booksApiService = BooksApiService();

  // 検索フォームのコントローラー
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _publisherController = TextEditingController();
  String _selectedGenre = '동화';

  final List<String> _genres = [
    '동화',
    '고전',
    '전후소설',
    '풍자',
    '디스토피아'
  ];

  @override
  get init => () async {
    _books = await booksApiService.findAll();
    _filteredBooks = _books;
  };

  void _filterBooks() {
    if (_books == null) return;

    _filteredBooks = _books!.where((book) {
      final titleMatch = _titleController.text.isEmpty || 
          (book.title?.toLowerCase().contains(_titleController.text.toLowerCase()) ?? false);
      final authorMatch = _authorController.text.isEmpty || 
          (book.author?.toLowerCase().contains(_authorController.text.toLowerCase()) ?? false);
      final publisherMatch = _publisherController.text.isEmpty || 
          (book.publisher?.toLowerCase().contains(_publisherController.text.toLowerCase()) ?? false);
      final genreMatch = book.genre == _selectedGenre;

      return titleMatch && authorMatch && publisherMatch && genreMatch;
    }).toList();
    setState(() {});
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('고급검색'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: '제목',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _filterBooks(),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: '저자',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _filterBooks(),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _publisherController,
                  decoration: const InputDecoration(
                    labelText: '출판사',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _filterBooks(),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('장르', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _genres.map((genre) => ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedGenre = genre;
                          });
                          _filterBooks();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedGenre == genre ? Colors.blue : Colors.grey[200],
                          foregroundColor: _selectedGenre == genre ? Colors.white : Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          genre,
                          style: const TextStyle(fontSize: 12),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredBooks == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredBooks!.length,
                    itemBuilder: (context, index) {
                      final book = _filteredBooks![index];
                      return ListTile(
                        title: Text(book.title ?? '제목 없음'),
                        subtitle: Text(book.author ?? '저자 미상'),
                        leading: book.imageUrl != null
                            ? Image.network(
                                "${getEnv('API_BASE_URL')}${book.imageUrl}",
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.book),
                        trailing: Text('¥${book.price ?? 0}'),
                        onTap: () {
                          routeTo('/book-detail', queryParameters: { "id": book.bookId.toString() });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    super.dispose();
  }
}
