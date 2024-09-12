import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Importing the splash screen
import 'login_screen.dart'; // Importing the login screen
import 'registeration_page.dart'; // Importing the registration screen
import 'features.dart'; // Importing the features screen
import 'todo.dart'; // Importing the to-do list screen
// import 'mood_tracker.dart'; // Importing the mood tracker screen (if needed)

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Handle named routes with arguments
        if (settings.name == '/todo') {
          final String userId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => TodoPage(userId: userId),
          );
        }
        // Add more routes if needed here
        return null; // If no matching route is found
      },
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signUp': (context) => RegisterScreen(),
        '/home': (context) => HomePage(),
        '/features': (context) => Features(),
        // Remove direct route definition for /todo
        // '/todo': (context) => TodoPage(), // Commented out as it's handled by onGenerateRoute
        // '/moodTracker': (context) => MoodTrackerScreen(), // Define this route if needed
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Dashboard',
          style: TextStyle(fontSize: 24),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.track_changes),
              title: Text('Mood Tracker'),
              onTap: () {
                Navigator.pushNamed(context, '/moodTracker');
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('To-Do List'),
              onTap: () {
                // Ensure you pass userId as an argument
                Navigator.pushNamed(
                  context,
                  '/todo',
                  arguments: 'exampleUserId', // Replace with actual userId
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
