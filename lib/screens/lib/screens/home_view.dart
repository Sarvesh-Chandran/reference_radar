import 'package:flutter/material.dart';
import 'detail_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // TEMPORARY DUMMY DATA (REMOVE LATER WHEN API IS READY)
  List<String> books = [
    "Clean Code",
    "Design Patterns",
    "Flutter in Action",
    "Introduction to Algorithms"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //  hedr
              const Text(
                "Search academic references for your study",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              // SEARCH BOX (API CONNECT LATER HERE)
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                //LATER: THIS SINI WILL BE SENT TO API TO SEARCH
                  hintText: "Search books or authors...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Recommended Books",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // BOOK LIST (WILL BE API DATA LATER)
              Expanded(
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.menu_book),
                        title: Text(books[index]),
                        // LATER: AUTHOR COMES FROM API
                        subtitle: const Text("Author (from API later)"), 

                        // DETAIL NAVIGATION
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailView(
                                title: books[index],
                                author: "Author (API later)",
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
                    // THIS BUTTON SHOULD LATER:
                    // - ADD TASK TO SAVED SCREEN (TASK 2 MEMBER?)
                  },
                  child: const Text("➕ Add Study Task"), //PAS TKN NI ISI TEHN SAVED DI SAVED TASStorage Coder (Task 2): Write the SharedPreferences logic to save and load our local to-do list)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}