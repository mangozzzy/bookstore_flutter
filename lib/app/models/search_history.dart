import 'package:nylo_framework/nylo_framework.dart';

class SearchHistory extends Model {
  final String? title;
  final String? author;
  final String? publish;
  final String? genre;
  final String? keyword;
  final String? searchedAt;

  static StorageKey key = "search_history";
  
  SearchHistory({
    this.title,
    this.author,
    this.genre,
    this.keyword,
    this.publish,
    this.searchedAt,
  }) : super(key: key);
  
  factory SearchHistory.fromJson(data)  {
    return SearchHistory(
      title: data['title'],
      author: data['author'],
      publish: data['publish'],
      genre: data['genre'],
      keyword: data['keyword'],
      searchedAt: data['searchedAt'],
    );
  }

  @override
  toJson() {
    return {};
  }
}
