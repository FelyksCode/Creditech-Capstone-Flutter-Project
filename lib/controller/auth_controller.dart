import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:creditech_capstone_project/services/auth_service.dart';
import 'package:creditech_capstone_project/services/firestore_service.dart';
import 'package:creditech_capstone_project/controller/profile_provider.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  ProfileProvider? _profileProvider;

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthController() {
    // Initialize current user immediately
    _user = _authService.currentUser;
    
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      
      // If user logs in and profile provider is set, refresh profile data
      if (user != null && _profileProvider != null) {
        try {
          await _profileProvider!.refreshUserData();
        } catch (e) {
          _setError('Unable to refresh profile. Please check your internet connection and try again.');
        }
      }
      
      // Clear profile data if user logs out
      if (user == null && _profileProvider != null) {
        _profileProvider!.resetProfile();
      }
      
      notifyListeners();
    });
  }

  // Set profile provider for authentication data integration
  void setProfileProvider(ProfileProvider profileProvider) {
    _profileProvider = profileProvider;
  }

  // Initialize dependencies from Provider context
  void initializeDependencies(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(
      context,
      listen: false,
    );
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );

    // Set up dependencies
    profileProvider.setFirestoreService(firestoreService);
    setProfileProvider(profileProvider);
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final credential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential != null && credential.user != null) {
        // For login, refresh profile data for the current user
        if (_profileProvider != null) {
          await _profileProvider!.refreshUserData();
        }
        return true;
      }

      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register with email and password
  Future<bool> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final credential = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential != null && credential.user != null) {
        // Save email/password user data to Firestore if profile provider is available
        if (_profileProvider != null) {
          await _profileProvider!.saveEmailPasswordUserData(credential.user!);
        }
        return true;
      }

      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);

      final credential = await _authService.signInWithGoogle();

      if (credential != null && credential.user != null) {
        // For Google sign-in, only save profile data if it's a new user
        if (_profileProvider != null) {
          await _profileProvider!.saveGoogleAccountDataIfNew(credential.user!);
          // Refresh profile data to ensure latest data is loaded
          await _profileProvider!.refreshUserData();
        }
        return true;
      }

      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _authService.signOut();
      
      // Clear any stored profile data
      if (_profileProvider != null) {
        _profileProvider!.resetProfile();
      }
      
      // Clear auth controller state
      _user = null;
      _errorMessage = null;
      
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);

      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
