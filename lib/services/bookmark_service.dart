import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const String _key = 'saved_books';

  static Future<void> saveBook({
    required String title,
    required String author,
    required String workKey,
    required String coverId,
    required String firstPublishYear,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final String? data = prefs.getString(_key);
    List savedBooks = data == null ? [] : jsonDecode(data);

    final alreadySaved = savedBooks.any((book) => book['workKey'] == workKey);

    if (!alreadySaved) {
      savedBooks.add({
        'title': title,
        'author': author,
        'workKey': workKey,
        'coverId': coverId,
        'firstPublishYear': firstPublishYear,
      });

      await prefs.setString(_key, jsonEncode(savedBooks));
    }
  }
}