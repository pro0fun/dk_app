import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({
    Key? key, // ✅ Add this
    required this.user,
  }) : super(key: key); // ✅ Pass key to super

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome ${user.displayName ?? 'User'}")), // fallback if displayName is null
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Logged in as: ${user.email ?? 'unknown'}"),
            const SizedBox(height: 20), // ✅ spacing improvement
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              child: const Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
