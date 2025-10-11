import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:creditech_capstone_project/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthController() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
    
    // Initialize current user
    _user = _authService.currentUser;
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
      
      return credential != null;
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
      
      return credential != null;
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
      
      return credential != null;
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