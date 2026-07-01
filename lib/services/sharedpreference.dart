import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AssignmentStorageService {
  static const String _storageKey = 'assignments_list_key';

  // Save the entire list of assignments as a JSON string
  static Future<void> saveAssignments(List<String> assignments) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(assignments); // Encodes the List to "[...]"
    await prefs.setString(_storageKey, jsonString);
  }

  // Load the JSON string and decode it back into a List<String>
  static Future<List<String>> loadAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);

    if (jsonString == null) return []; // Return an empty list if nothing is saved yet

    // Decode the JSON string back into a List
    final List<dynamic> decodedList = jsonDecode(jsonString);
    return decodedList.cast<String>(); // Convert it safely to a List of Strings
  }
}