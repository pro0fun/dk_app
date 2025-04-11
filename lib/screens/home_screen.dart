import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dk_app/screens/login_page.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${user.displayName ?? 'User'}"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user.photoURL != null)
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user.photoURL!),
              )
            else
              const CircleAvatar(
                radius: 30,
                child: Icon(Icons.person, size: 30),
              ),
            const SizedBox(height: 10),
            Text(
              "Logged in as: ${user.email ?? 'unknown'}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "UID: ${user.uid}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signOut,
              child: const Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
