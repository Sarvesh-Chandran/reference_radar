import 'package:flutter/material.dart';
import 'detail_view.dart';

import 'package:reference_radar/models/book.dart';
import 'package:reference_radar/services/openlibrary_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'saved_books.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController searchController = TextEditingController();
  final OpenLibraryService api = OpenLibraryService();

  List<Book> books = [];

  // stating variables for the rubric requirements
  bool isLoading = false;
  String errorMessage = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  //  working search function
  Future<void> searchBooks() async {
    // Hide keyboard when searching
    FocusScope.of(context).unfocus();

    if (searchController.text.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final result = await api.searchBooks(searchController.text);
      setState(() {
        books = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load books. Please check your connection.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Search academic references for your study",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // SEARCH BOX
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search books or authors...",
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: searchBooks,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted: (_) => searchBooks(),
                ),
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavedBooksView(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.bookmark),
                    label: const Text("View Saved Books"),
                  ),
                ),

                const Text(
                  "Recommended Books",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // UI logic for Loading, Error, and List
                isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : errorMessage.isNotEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      )
                    : books.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("Search for a book to get started!"),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.menu_book),
                              title: Text(books[index].title),
                              subtitle: Text(books[index].author),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailView(
                                      title: books[index].title,
                                      author: books[index].author,
                                      workKey: books[index].workKey,
                                      coverId: books[index].coverId,
                                      firstPublishYear:
                                          books[index].firstPublishYear,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),

                const SizedBox(height: 20),

                // THUMB-ZONE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      String taskText = searchController.text.trim();

                      if (taskText.isEmpty) {
                        taskText = "New Study Reference Task";
                      }

                      final prefs = await SharedPreferences.getInstance();
                      String? existingData = prefs.getString(
                        'assignments_list_key',
                      );

                      List<String> favoritesList = [];
                      if (existingData != null) {
                        final List<dynamic> decodedList = jsonDecode(
                          existingData,
                        );
                        favoritesList = decodedList.cast<String>();
                      }

                      if (!favoritesList.contains(taskText)) {
                        favoritesList.add(taskText);
                        String updatedData = jsonEncode(favoritesList);
                        await prefs.setString(
                          'assignments_list_key',
                          updatedData,
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '"$taskText" added to Study Tasks!',
                              ),
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '"$taskText" is already in Study Tasks!',
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text("➕ Add Study Task"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
