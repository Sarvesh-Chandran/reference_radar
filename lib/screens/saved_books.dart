import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_view.dart';

class SavedBooksView extends StatefulWidget {
  const SavedBooksView({super.key});

  @override
  State<SavedBooksView> createState() => _SavedBooksViewState();
}

class _SavedBooksViewState extends State<SavedBooksView> {
  List savedBooks = [];

  @override
  void initState() {
    super.initState();
    loadSavedBooks();
  }

  Future<void> loadSavedBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('saved_books');

    setState(() {
      savedBooks = data == null ? [] : jsonDecode(data);
    });
  }

  Future<void> deleteBook(int index) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      savedBooks.removeAt(index);
    });

    await prefs.setString('saved_books', jsonEncode(savedBooks));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Books"),
      ),
      body: savedBooks.isEmpty
          ? const Center(
              child: Text("No saved books yet."),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedBooks.length,
              itemBuilder: (context, index) {
                final book = savedBooks[index];

                return Card(
                  child: ListTile(
                    leading: book['coverId'] != null &&
                            book['coverId'].toString().isNotEmpty
                        ? Image.network(
                            "https://covers.openlibrary.org/b/id/${book['coverId']}-S.jpg",
                            width: 45,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.menu_book);
                            },
                          )
                        : const Icon(Icons.menu_book),
                    title: Text(book['title'] ?? 'No Title'),
                    subtitle: Text(book['author'] ?? 'Unknown Author'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => deleteBook(index),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailView(
                            title: book['title'] ?? 'No Title',
                            author: book['author'] ?? 'Unknown Author',
                            workKey: book['workKey'] ?? '',
                            coverId: book['coverId'] ?? '',
                            firstPublishYear:
                                book['firstPublishYear'] ?? 'Unknown',
                          ),
                        ),
                      ).then((_) => loadSavedBooks());
                    },
                  ),
                );
              },
            ),
    );
  }
}