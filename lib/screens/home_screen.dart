import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dk_app/screens/login_page.dart';
import 'package:dk_app/screens/complete_profile_screen.dart'; // New screen

class HomeScreen extends StatefulWidget {
  final User user;
  final bool isFirstLogin;  // Add this line

  const HomeScreen({
    super.key,
    required this.user,
    required this.isFirstLogin,  // Make sure it's passed in the constructor
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkIfProfileIsCompleted();
  }

  Future<void> _checkIfProfileIsCompleted() async {
    try {
      final uid = widget.user.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!doc.exists || !(doc.data()?['profileCompleted'] ?? false)) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CompleteProfileScreen(user: widget.user),
              ),
            );
          });
        }
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint("Error checking profile status: $e");
      setState(() {
        _loading = false; // Still allow user to use the app even if check fails
      });
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
