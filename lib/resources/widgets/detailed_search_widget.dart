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

  final booksApiService = BooksApiService();

  @override
  get init => () async {
    _books = await booksApiService.findAll();
  };

  @override
  Widget view(BuildContext context) {
    return Container(
      child: _books == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _books!.length,
              itemBuilder: (context, index) {
                final book = _books![index];
                return ListTile(
                  title: Text(book.title ?? 'タイトルなし'),
                  subtitle: Text(book.author ?? '著者不明'),
                  leading: book.imageUrl != null
                      ? Image.network(
                          "${getEnv('API_BASE_URL')}${book.imageUrl}",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.book),
                  trailing: Text('¥${book.price ?? 0}'),
                );
              },
            ),
    );
  }
}
