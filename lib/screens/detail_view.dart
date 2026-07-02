import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:reference_radar/services/openlibrary_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:reference_radar/services/bookmark_service.dart';
import 'package:reference_radar/widgets/premium_dialog.dart';

class DetailView extends StatefulWidget {
  final String title;
  final String author;
  final String workKey;
  final String coverId;
  final String firstPublishYear;

  const DetailView({
    super.key,
    required this.title,
    required this.author,
    required this.workKey,
    required this.coverId,
    required this.firstPublishYear,
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

  Future<void> openBook() async {
    final Uri url = Uri.parse("https://openlibrary.org${widget.workKey}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // OUTER COLUMN: Separates the scrollable content from the sticky buttons
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.coverId.isNotEmpty)
                      Center(
                        child: Image.network(
                          "https://covers.openlibrary.org/b/id/${widget.coverId}-L.jpg",
                          height: MediaQuery.of(context).size.height * 0.25,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.menu_book, size: 120);
                          },
                        ),
                      ),

                    const SizedBox(height: 16),

                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
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

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        const SizedBox(width: 8),
                        const Text(
                          "First Published:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(widget.firstPublishYear)),
                      ],
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

                    description == "Loading..."
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            description,
                            style: const TextStyle(fontSize: 15, height: 1.5),
                          ),

                    const SizedBox(
                      height: 20,
                    ), // Extra padding before the buttons
                  ],
                ),
              ),
            ),

            // BUTTONS GO HERE (Anchored safely to the bottom)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();

                        final bool isPremium =
                            prefs.getBool('is_premium') ?? false;
                        final String? data = prefs.getString('saved_books');
                        final List savedBooks = data == null
                            ? []
                            : jsonDecode(data);

                        if (!isPremium && savedBooks.length >= 3) {
                          final bool? upgraded = await showDialog<bool>(
                            context: context,
                            builder: (context) => const PremiumDialog(),
                          );

                          if (upgraded == true) {
                            await prefs.setBool('is_premium', true);

                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Welcome to Premium! Unlimited saves unlocked.",
                                ),
                              ),
                            );
                          } else {
                            return;
                          }
                        }

                        await BookmarkService.saveBook(
                          title: widget.title,
                          author: widget.author,
                          workKey: widget.workKey,
                          coverId: widget.coverId,
                          firstPublishYear: widget.firstPublishYear,
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Book saved successfully!"),
                          ),
                        );
                      },
                      child: const Text("Bookmark"),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: openBook,
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
