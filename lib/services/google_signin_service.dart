import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Logger logger = Logger();  // Initialize the logger

  // Sign in with Google
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? user = await _googleSignIn.signIn();
      logger.i('Successfully signed in with Google'); // Info level log
      return user;
    } catch (error) {
      logger.e('Error signing in with Google: $error'); // Error level log
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    logger.i('Successfully signed out'); // Info level log
  }

  // Check if already signed in
  Future<GoogleSignInAccount?> getCurrentUser() async {
    GoogleSignInAccount? user = _googleSignIn.currentUser;
    if (user != null) {
      logger.i('User is already signed in: ${user.displayName}'); // Info level log
    } else {
      logger.i('No user is currently signed in'); // Info level log
    }
    return user;
  }
}
