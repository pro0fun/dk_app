import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dk_app/login_page.dart';  // Ensure the correct package name

class HomeScreen extends StatefulWidget {
  final User user;

  // Constructor with required User parameter
  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${widget.user.displayName ?? 'User'}"),  // Access user data from widget
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Logged in as: ${widget.user.email ?? 'unknown'}",  // Display user email
              style: const TextStyle(fontSize: 18),  // Optional styling for readability
            ),
            const SizedBox(height: 20),  // Improved spacing between text and button
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();  // Sign out from Firebase
                if (mounted) {  // Ensure context is valid before navigating
                  // Wrap the navigation in a post-frame callback to ensure it happens after the async gap
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginPage()), // Navigate to LoginPage
                      );
                    }
                  });
                }
              },
              child: const Text("Sign out"),  // Text inside the button
            ),
          ],
        ),
      ),
    );
  }
}
