import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'todo.dart'; // Import the TodoPage file

class Features extends StatefulWidget {
  @override
  _FeaturesState createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  late String userId;
  String? userName;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch the userId from the previous page
    userId = ModalRoute.of(context)!.settings.arguments as String;
    _fetchUserName();  // Fetch user details when the page loads
  }

  Future<void> _fetchUserName() async {
    try {
      // Make an API call to fetch user details
      final response = await http.get(Uri.parse('http://localhost:5000/api/user/$userId'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data['name'];  // Extract the user's name from the response
          isLoading = false;
        });
      } else {
        setState(() {
          userName = 'User';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        userName = 'Error fetching name';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.pinkAccent],
          ),
        ),
        child: Column(
          children: [
            // Top text with user name
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: isLoading
                    ? CircularProgressIndicator() // Show loader until data is fetched
                    : Text(
                        'Hello, ${userName ?? 'User'}', // Display the user's name
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
              ),
            ),
            // Grid of 4 boxes with icons
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: List.generate(4, (index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to TodoPage when Box 0 is tapped
                        if (index == 0) {
                          Navigator.pushNamed(
                          context,
                          '/todo',
                          arguments: userId, // Pass the userId as an argument
                          );
                          } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(index: index)),
                          );
                        }
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Icon(
                              Icons.open_in_new,
                              size: 24,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// New page that opens on tapping any container except Box 0
class DetailPage extends StatelessWidget {
  final int index;

  DetailPage({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page for Box $index'),
      ),
      body: Center(
        child: Text(
          'You opened box number $index',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
