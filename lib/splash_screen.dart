import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';  // For a loading animation, optional

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 3000), () {}); // Splash duration
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to home page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFAAD3E0), Color(0xFFffffff)], // Gradient from #AAD3E0 to white
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/logo.png', height: 120), // Your app logo
              SizedBox(height: 20),
              Text(
                'Welcome to Your App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              SpinKitFadingCircle( // Optional: Loading indicator
                color: Colors.blue,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
