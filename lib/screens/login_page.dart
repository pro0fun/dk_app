import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dk_app/services/google_signin_service.dart'; // Ensure correct path
import 'home_screen.dart';
import 'register_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String _errorMessage = '';

  final GoogleSignInService _googleSignInService = GoogleSignInService();

  // Track failed login attempts
  int _failedAttempts = 0;
  DateTime? _lockoutTime;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      GoogleSignInAccount? user = await _googleSignInService.signInWithGoogle();

      if (user != null) {
        final GoogleSignInAuthentication googleAuth = await user.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        if (!mounted) return;

        final firebaseUser = userCredential.user;
        if (firebaseUser == null) {
          setState(() {
            _errorMessage = 'Failed to sign in with Google.';
          });
          return;
        }

        // Check if it's the first login
        final userRef = FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid);
        final docSnapshot = await userRef.get();
        if (!docSnapshot.exists) {
          // First login, navigate to settings prompt
          if (!mounted) return; // Check for mounted before using context
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: firebaseUser, isFirstLogin: true), // Pass flag
            ),
          );
        } else {
          if (!mounted) return; // Check for mounted before using context
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: firebaseUser, isFirstLogin: false),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Google sign-in failed. Please try again.';
      });
      debugPrint("Error signing in with Google: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      if (_failedAttempts >= 3 && _lockoutTime != null && DateTime.now().isBefore(_lockoutTime!)) {
        setState(() {
          _errorMessage = 'Too many failed attempts. Please try again in 60 minutes.';
        });
        return;
      }

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (!mounted) return;

        final user = userCredential.user;
        if (user == null) {
          setState(() {
            _errorMessage = 'User not found.';
          });
          return;
        }

        // Reset failed attempts upon successful login
        setState(() {
          _failedAttempts = 0;
        });

        // Check if it's the first login
        final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final docSnapshot = await userRef.get();
        if (!docSnapshot.exists) {
          // First login, navigate to settings prompt
          if (!mounted) return; // Check for mounted before using context
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: user, isFirstLogin: true), // Pass flag
            ),
          );
        } else {
          if (!mounted) return; // Check for mounted before using context
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: user, isFirstLogin: false),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = _getErrorMessage(e);
        });

        if (e.code == 'wrong-password') {
          setState(() {
            _failedAttempts++;
            _errorMessage = 'Incorrect password. Please try again.';
          });
        }

        // Lockout after 3 failed attempts
        if (_failedAttempts >= 3) {
          _lockoutTime = DateTime.now().add(Duration(minutes: 60));
          setState(() {
            _errorMessage += '\nYou are locked out for 60 minutes.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An unexpected error occurred. Please try again.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email to reset password.')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset link sent! Check your email.')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getErrorMessage(e))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return e.message ?? 'Login failed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login to your account', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email.';
                  } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zAZ0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                    return 'Enter a valid email.';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).nextFocus();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password.';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  _login();
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _resetPassword,
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
                child: const Text('Don\'t have an account? Register'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
  onPressed: _signInWithGoogle,
  icon: const Icon(
    Icons.login, 
    color: Colors.white,
  ),
  label: const Text(
    "Sign in with Google",
    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 236, 236, 236), // Darker blue for better contrast
    foregroundColor: const Color.fromARGB(255, 255, 255, 255),    // White text color
  ),
),

              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
