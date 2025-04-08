import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // ✅ Make sure this exists!
import 'login_page.dart'; // ✅ Direct import from lib

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // ✅ Needed for Firebase to work on all platforms
  );

  runApp(const MyApp()); // ✅ Add const
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // ✅ Add Key to constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DK App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), // ✅ Use const if no dynamic content
    );
  }
}
