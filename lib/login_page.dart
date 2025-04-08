import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key); // ✅ Constructor updated

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Welcome to the DK App!"), // ✅ Use const when possible
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Here you would typically handle the login logic.
                // For now, just print a message.
                print("Login button pressed");
              },
              child: const Text("Login"), // ✅ Use const
            ),
          ],
        ),
      ),
    );
  }
}
