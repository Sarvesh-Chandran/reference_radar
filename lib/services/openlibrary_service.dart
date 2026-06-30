import 'dart:convert';

import 'package:http/http.dart'
    as http; // add 'http: ^1.2.1' under dependecies in pubspec.yaml,
//then run flutter pub get in terminal

import 'package:reference_radar/models/book.dart'; //import book model;nested file?

class OpenLibraryService {
  //fetch data from open library (title,author, cover img)
  //make API URL based on serach keyword
  Future<List<Book>> searchBooks(String query) async {
    try {
      final url = Uri.https('openlibrary.org', '/search.json', {'q': query});

      //sent HTTP GET req to source
      final response = await http.get(url);

      if (response.statusCode == 200) {
        //if request passed condition
        final json = jsonDecode(response.body);

        final List docs =
            json['docs']; //books in OpenLibrary is stored inside 'docs' list

        return docs.map((book) => Book.fromJson(book)).toList();
      } else {
        throw Exception(
          'Server error: ${response.statusCode}', //API return error if fetch failed
        );
      }
    } catch (e) {
      throw Exception(
        'Unable to connect to Open Library.', //return this if internet connection down or unexpected error
      );
    }
  }

  //second API to retrieve description (because Search API doesnt include description)
  Future<String> fetchDescription(String workKey) async {
    try {
      final url = Uri.https('openlibrary.org', '$workKey.json');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final description = json['description'];

        if (description == null) {
          return "No description available.";
        }

        if (description is String) {
          return description;
        }

        if (description is Map && description.containsKey('value')) {
          return description['value'];
        }

        return "No description available.";
      } else {
        throw Exception("Server error");
      }
    } catch (e) {
      return "Unable to load description.";
    }
  }
}
