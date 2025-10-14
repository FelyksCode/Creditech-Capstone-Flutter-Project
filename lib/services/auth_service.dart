import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Specify scopes if needed
    scopes: [
      'email',
      'profile',
    ],
  );

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // First, sign out from any existing Google sessions
      await _googleSignIn.signOut();
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User canceled the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Check if we have valid tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to obtain Google authentication tokens');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // More detailed Firebase Auth error handling
      String firebaseError = 'Firebase authentication failed';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          firebaseError = 'An account already exists with the same email but different sign-in credentials.';
          break;
        case 'invalid-credential':
          firebaseError = 'The credential received is malformed or has expired.';
          break;
        case 'operation-not-allowed':
          firebaseError = 'Google sign-in is not enabled for this project.';
          break;
        case 'user-disabled':
          firebaseError = 'The user account has been disabled.';
          break;
        case 'user-not-found':
          firebaseError = 'No user record found.';
          break;
        case 'wrong-password':
          firebaseError = 'Wrong password provided.';
          break;
        case 'invalid-verification-code':
          firebaseError = 'Invalid verification code.';
          break;
        case 'invalid-verification-id':
          firebaseError = 'Invalid verification ID.';
          break;
        default:
          firebaseError = 'Firebase authentication failed: ${e.code} - ${e.message}';
      }
      throw Exception(firebaseError);
    } catch (e) {
      // Handle specific Google Sign-In errors with more details
      String errorMessage = 'Google sign-in failed';
      String errorDetails = e.toString();
      
      if (errorDetails.contains('PlatformException')) {
        if (errorDetails.contains('sign_in_failed')) {
          if (errorDetails.contains('ApiException: 10')) {
            errorMessage = 'Google Sign-In configuration error (Code 10). The SHA-1 fingerprint may not be properly configured in Firebase Console.';
          } else if (errorDetails.contains('ApiException: 7')) {
            errorMessage = 'Network error. Please check your internet connection.';
          } else if (errorDetails.contains('ApiException: 12501')) {
            errorMessage = 'Google Sign-In was canceled by user.';
          } else if (errorDetails.contains('ApiException: 16')) {
            errorMessage = 'Google Sign-In internal error. Please try again.';
          } else {
            errorMessage = 'Google Sign-In failed with error: $errorDetails';
          }
        } else if (errorDetails.contains('sign_in_canceled')) {
          errorMessage = 'Google Sign-In was canceled.';
        } else {
          errorMessage = 'Google Sign-In platform error: $errorDetails';
        }
      } else if (errorDetails.contains('network_error')) {
        errorMessage = 'Network error. Please check your internet connection and try again.';
      } else {
        errorMessage = 'Google sign-in failed: $errorDetails';
      }
      
      throw Exception(errorMessage);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email address. Please check your email or create a new account.';
      case 'wrong-password':
        return 'Incorrect password. Please check your password and try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check your credentials and try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address. Please use a different email or sign in instead.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters with a mix of letters and numbers.';
      case 'invalid-email':
        return 'Please enter a valid email address format (example@email.com).';
      case 'user-disabled':
        return 'This account has been temporarily disabled. Please contact support for assistance.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please wait a few minutes before trying again.';
      case 'operation-not-allowed':
        return 'Email/password authentication is currently disabled. Please contact support.';
      case 'network-request-failed':
        return 'Network connection failed. Please check your internet connection and try again.';
      case 'requires-recent-login':
        return 'Please sign out and sign in again to perform this action.';
      default:
        return 'Authentication failed: ${e.message ?? 'Unknown error occurred. Please try again.'}';
    }
  }
}
