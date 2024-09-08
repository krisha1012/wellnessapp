import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Importing the splash screen
import 'login_screen.dart'; // Importing the login screen
import 'registeration_page.dart'; // Importing the registration screen
import 'features.dart'; //Importing the features screen

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
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signUp': (context) => RegisterScreen(), // Registration page route
        '/home': (context) => HomePage(),
        '/features': (context) => Features(),
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
                Navigator.pushNamed(context, '/toDoList');
              },
            ),
            // Add more features here as needed
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
