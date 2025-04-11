import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Logger _logger = Logger();

  // Sign in with Google
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        _logger.i('Successfully signed in with Google as ${user.displayName}');
      } else {
        _logger.w('Google sign-in was cancelled by the user.');
      }
      return user;
    } catch (error, stackTrace) {
      _logger.e('Error during Google sign-in: $error', error, stackTrace);
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _logger.i('Successfully signed out from Google.');
    } catch (error, stackTrace) {
      _logger.e('Error during Google sign-out: $error', error, stackTrace);
    }
  }

  // Check if already signed in
  Future<GoogleSignInAccount?> getCurrentUser() async {
    final user = _googleSignIn.currentUser;
    if (user != null) {
      _logger.i('User already signed in: ${user.displayName}');
    } else {
      _logger.i('No user is currently signed in.');
    }
    return user;
  }
}
