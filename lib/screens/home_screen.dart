import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  // Constructor with a Key and required User parameter
  const HomeScreen({
    super.key,
    required this.user,  // Required user data passed to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${user.displayName ?? 'User'}"),  // Display name or fallback text if null
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Logged in as: ${user.email ?? 'unknown'}",  // Display user email or 'unknown' if null
              style: const TextStyle(fontSize: 18),  // Optional styling for better readability
            ),
            const SizedBox(height: 20),  // Improved spacing between the text and the button
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();  // Sign out from Firebase
                Navigator.pop(context);  // Navigate back to the previous screen (login page)
              },
              child: const Text("Sign out"),  // Text inside the button
            ),
          ],
        ),
      ),
    );
  }
}
