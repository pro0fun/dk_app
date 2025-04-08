import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Ensure this file exists and is generated correctly
import 'login_page.dart'; // Import your login page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensures that the Flutter engine is initialized.
  
  // Firebase initialization, passing the correct options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // Firebase options for all platforms (iOS, Android, etc.)
  );

  runApp(const MyApp());  // Starts the app with the MyApp widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});  // Constructor with a key to support widget keys

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DK App',  // Title of the app that shows up on the home screen
      theme: ThemeData(
        primarySwatch: Colors.blue,  // Setting the primary color theme for your app
      ),
      home: const LoginPage(),  // Starting screen of the app, LoginPage here
    );
  }
}
