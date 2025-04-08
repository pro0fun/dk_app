import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  // Constructor with the key being forwarded to the parent class
  const LoginPage({super.key}); // ✅ Constructor updated

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"), // ✅ Using const to optimize widget rebuilding
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Welcome to the DK App!"), // ✅ Use const when possible
            const SizedBox(height: 20), // ✅ Using const for SizedBox
            ElevatedButton(
              onPressed: () {
                // Here you would typically handle the login logic.
                // For now, just print a message.
                debugPrint("Login button pressed");
              },
              child: const Text("Login"), // ✅ Use const for Text widget
            ),
          ],
        ),
      ),
    );
  }
}
