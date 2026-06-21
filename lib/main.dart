import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const ReferenceRadarApp());

// ── LEADER & SETUP (Sarvesh) ──────────────────────────────────────────
// Handled project setup, ThemeData, BottomNavigationBar, and final integration.
class ReferenceRadarApp extends StatelessWidget {
  const ReferenceRadarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reference Radar',
      // Taken ThemeData setup directly from Lab 4
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}

// ── MainNavigation: manages the tab state (From Lab 2) ───────────────
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0; // tracks the active tab

  // These are the three dummy screens the team will work on
  final List<Widget> _screens = [
    const HomeView(),
    const SavedView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reference Radar'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _screens[_selectedIndex],
      // Bottom navigation setup from Lab 2
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved Tasks',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Premium'),
        ],
      ),
    );
  }
}

// ── TASK 1 & 3 UI: API Search & Display ──────────────────────────────
// @Fitri (UI/UX Coder): Design this Home screen and the Detail screen.
// Make sure to use a Spacer() to push primary buttons to the thumb-zone at the bottom
//
// @Ivy (API Backend): You won't code directly in this file. Create a new file in
// lib/services/ for the HTTP GET request to the Open Library API.
//
// @Tiara (API Frontend): Build the ListView.builder here to show the books Ivy fetches.
// You must include a CircularProgressIndicator while loading and show a user-friendly error message if it fails *from rubric so kinda important*.
class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home View - API Book Search Goes Here'));
  }
}

// ── TASK 2 UI: Data Persistence ──────────────────────────────────────
// @Farhan DS (Storage Coder): Build the local To-Do list UI here.
// You MUST use SharedPreferences to save and load the list of assignments.
// Remember to use jsonEncode to save the list, and jsonDecode to load it in initState().

class SavedView extends StatefulWidget {
  const SavedView({super.key});

  @override
  State<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> {
  final TextEditingController _taskController = TextEditingController();
  List<String> _assignments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignments();   // to load saved items when screen initializes
  }

  // load list from SharedPreferences by using jsonDecode
  Future<void> _loadAssignments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedData = prefs.getString('saved_assignments');
      
      if (savedData != null) {
        // Decode the JSON string back into a dynamic list, then cast to String list
        final List<dynamic> decodedList = jsonDecode(savedData);
        setState(() {
          _assignments = decodedList.map((item) => item.toString()).toList();
        });
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // to save list to SharedPreferences by using jsonEncode
  Future<void> _saveAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    // Encode the list into a JSON string format
    final String encodedData = jsonEncode(_assignments);
    await prefs.setString('saved_assignments', encodedData);
  }

  // add a new assignment to the list
  void _addAssignment() {
    if (_taskController.text.trim().isEmpty) return;

    // NOTE FOR CLARISSA (Task 4):  can you hook into this block to trigger?
    // your premium paywall dialog if (_assignments.length >= limit)
    
    setState(() {
      _assignments.add(_taskController.text.trim());
      _taskController.clear();
    });
    _saveAssignments();
  }

  // to remove an assignment from the list
  void _deleteAssignment(int index) {
    setState(() {
      _assignments.removeAt(index);
    });
    _saveAssignments();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      Widget: Column(
        children: [
          // the input section to type new assignments
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(
                    labelText: 'New Assignment / Task',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _addAssignment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // display list of tasks
          Expanded(
            child: _assignments.isEmpty
                ? const Center(
                    child: Text(
                      'No saved assignments yet :).\nAdd one above!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _assignments.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(_assignments[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _deleteAssignment(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── TASK 4 UI: Monetisation ──────────────────────────────────────────
// @Clarissa (Monetisation): Build the Premium Subscription screen here.
// You need to show realistic fictional prices (e.g., RM 9.90).
// You also need to build the simulated paywall AlertDialog that triggers
// when a free user tries to add too many items to their To-Do list.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Premium View - Subscription Plans Go Here'),
    );
  }
}
