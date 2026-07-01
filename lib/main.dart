import 'package:flutter/material.dart';
import 'screens/home_view.dart';
import 'package:reference_radar/services/sharedpreference.dart';

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
  List<String> _assignments = [];
  final TextEditingController _assignmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Load the list when the screen starts
  }

  // 1. Load data from SharedPreferences using our service
  Future<void> _loadInitialData() async {
    final savedList = await AssignmentStorageService.loadAssignments();
    setState(() {
      _assignments = savedList;
    });
  }

  // 2. Add a new assignment and save the updated list
  Future<void> _addAssignment() async {
    if (_assignmentController.text.trim().isEmpty) return;

    setState(() {
      _assignments.add(_assignmentController.text.trim());
    });

    _assignmentController.clear();
    await AssignmentStorageService.saveAssignments(
      _assignments,
    ); // Save list via JSON
  }

  // 3. Delete an assignment and save the updated list
  Future<void> _deleteAssignment(int index) async {
    setState(() {
      _assignments.removeAt(index);
    });
    await AssignmentStorageService.saveAssignments(
      _assignments,
    ); // Save list via JSON
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Input row for adding new assignments
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _assignmentController,
                  decoration: const InputDecoration(
                    labelText: 'Enter new assignment...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _addAssignment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // The scrollable To-Do List view
          Expanded(
            child: _assignments.isEmpty
                ? const Center(child: Text('No assignments saved yet!'))
                : ListView.builder(
                    itemCount: _assignments.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(_assignments[index]),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
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
