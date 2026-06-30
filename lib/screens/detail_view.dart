import 'package:flutter/material.dart';
import 'package:reference_radar/services/openlibrary_service.dart';

class DetailView extends StatefulWidget {
  final String title;
  final String author;
  final String workKey;

  const DetailView({
    super.key,
    required this.title,
    required this.author,
    required this.workKey,
  });

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  final OpenLibraryService api = OpenLibraryService();

  String description = "Loading...";

  @override
  void initState() {
    super.initState();
    loadDescription();
  }

  Future<void> loadDescription() async {
    final result = await api.fetchDescription(widget.workKey);

    setState(() {
      description = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              "By ${widget.author}",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "📖 Description",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            //  Wrapped in Expanded and SingleChildScrollView to prevent pixel overflow crash
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                // BUTANG BOOKMARK
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO (Task 2 - Storage Coder):
                        // Save this book into SharedPreferences favourites list
                      },
                      child: const Text("Bookmark"),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // READ  BUTTON
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // OPTIONAL (Task 3 - API team or future enhancement):
                      },
                      child: const Text("Read"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
