//fetch data from Open Library: book title,author name, book cover img, description 
class Book {
  final String title;
  final String author;
  final String coverId;
  final String workKey;
  final String firstPublishYear;

  // Constructor
  Book({
    required this.title,
    required this.author,
    required this.coverId,
    required this.workKey,
    required this.firstPublishYear,
  });

  // Convert JSON object from API into Book object
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? 'No Title',

      author: (json['author_name'] != null &&
              json['author_name'] is List &&
              json['author_name'].isNotEmpty)
          ? json['author_name'][0]
          : 'Unknown Author',

      coverId: json['cover_i']?.toString() ?? '',

      workKey: json['key'] ?? '',

      // NEW
      firstPublishYear:
          json['first_publish_year']?.toString() ?? 'Unknown',
    );
  }
}