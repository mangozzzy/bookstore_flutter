import 'package:nylo_framework/nylo_framework.dart';

class PasswordSearch extends Model {
  final String message;

  static StorageKey key = "password_search";
  
  PasswordSearch({
      required this.message,
    }) : super(key: key);
  
  factory PasswordSearch.fromJson(data) {
    return PasswordSearch(message: data['message']);
  }

  @override
  toJson() {
    return {};
  }
}
