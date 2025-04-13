import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CompleteProfileScreen extends StatefulWidget {
  final User user;
  final bool isFirstLogin;

  const CompleteProfileScreen({super.key, required this.user, this.isFirstLogin = false});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _sex;
  String? _themePreference;

  bool _isLoading = false;

  @override
  void dispose() {
    _ageController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).set({
        'age': _ageController.text,
        'dob': _dobController.text,
        'sex': _sex,
        'themePreference': _themePreference,
        'isFirstLogin': false,
      });

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Error saving profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Complete your profile to get started', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dobController,
              decoration: const InputDecoration(labelText: 'Date of Birth (DD/MM/YYYY)'),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              hint: const Text('Select Sex'),
              value: _sex,
              onChanged: (value) {
                setState(() {
                  _sex = value;
                });
              },
              items: ['Male', 'Female', 'Other']
                  .map((sex) => DropdownMenuItem<String>(value: sex, child: Text(sex)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              hint: const Text('Select Theme Preference'),
              value: _themePreference,
              onChanged: (value) {
                setState(() {
                  _themePreference = value;
                });
              },
              items: ['Light', 'Dark']
                  .map((theme) => DropdownMenuItem<String>(value: theme, child: Text(theme)))
                  .toList(),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save Profile'),
                  ),
          ],
        ),
      ),
    );
  }
}
