import 'package:flutter/material.dart';

class DetailView extends StatelessWidget {
  final String title;
  final String author; 

  const DetailView({super.key, 
    required this.title, 
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              "By $author",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "📖 Description",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              // LATER: This comes from API
              "This is a placeholder for book details. Later this will be replaced with API data from Open Library.",
            ),

            const Spacer(),

            Row(
              children: [
                //BUTANG BOOKMARK
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

                //BUTANG READ
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // OPTIONAL (Task 3 - API team or future enhancement):
                        // Open external link OR show reading page?
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