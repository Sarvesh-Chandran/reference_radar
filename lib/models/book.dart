//fetch data from Open Library: book title,author name, book cover img, description 
class Book {
  final String title;
  final String author;
  final String coverId; // unused for now. if want can be used later to display book cover (future enhancement)
  final String workKey;

//constructor
  Book({
    required this.title,
    required this.author,
    required this.coverId,
    required this.workKey,
  });

//convert JSON object from API into book object
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? 'No Title',//return 'No Title' if title missing
      author: (json['author_name'] != null && //handles author name
              json['author_name'] is List &&
              json['author_name'].isNotEmpty)
          ? json['author_name'][0]
          : 'Unknown Author',
      coverId: json['cover_i']?.toString() ?? '',
      workKey: json['key'] ?? '',
    );
  }
}