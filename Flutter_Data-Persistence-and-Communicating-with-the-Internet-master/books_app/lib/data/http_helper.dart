import 'dart:convert';

import 'package:books_app/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HttpHelper {
  final String authority = 'www.googleapis.com';
  final String path = '/books/v1/volumes';
  Map<String, dynamic> params = {
    'q': "query",
    'maxResults': '40',
  };

  Future<List<Book>> getBooks(String query) async {
    Uri uri = Uri.https(authority, path, params);
    Response result = await http.get(uri);
    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);
      final booksMap = jsonResponse['items'];
      List<Book> books = booksMap.map<Book>((i) => Book.fromJson(i)).toList();
      return books;
    } else {
      return [];
    }
  }
}
