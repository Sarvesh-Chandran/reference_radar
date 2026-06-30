import 'package:flutter/material.dart';
import 'detail_view.dart';

import 'package:reference_radar/models/book.dart';
import 'package:reference_radar/services/openlibrary_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController searchController = TextEditingController();
  final OpenLibraryService api = OpenLibraryService();

  List<Book> books = [];

  // State variables for the rubric requirements
  bool isLoading = false;
  String errorMessage = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // 2. The actual working search function
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
                onSubmitted: (_) =>
                    searchBooks(), // Allows searching by pressing Enter
              ),
              const SizedBox(height: 20),

              const Text(
                "Recommended Books",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // 3. UI Logic for Loading, Error, and List
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      ) // Rubric requirement
                    : errorMessage.isNotEmpty
                    ? Center(
                        child: Text(
                          errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ) // Rubric requirement
                    : books.isEmpty
                    ? const Center(
                        child: Text("Search for a book to get started!"),
                      )
                    : ListView.builder(
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
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),

              // THUMB-ZONE BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO (Task 2 - Storage Coder)
                  },
                  child: const Text("➕ Add Study Task"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
