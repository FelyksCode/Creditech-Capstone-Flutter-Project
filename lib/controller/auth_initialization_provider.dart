import 'package:flutter/material.dart';
import 'package:creditech_capstone_project/controller/auth_controller.dart';
import 'package:creditech_capstone_project/controller/profile_provider.dart';
import 'package:creditech_capstone_project/controller/notification_provider.dart';
import 'package:creditech_capstone_project/services/firestore_service.dart';

class AuthInitializationProvider extends ChangeNotifier {
  bool _isInitializing = true;
  String? _initializationError;
  bool _hasInitialized = false;

  // Getters
  bool get isInitializing => _isInitializing;
  String? get initializationError => _initializationError;
  bool get hasInitialized => _hasInitialized;

  // Initialize authentication and related services
  Future<void> initializeAuth({
    required AuthController authController,
    required ProfileProvider profileProvider,
    required FirestoreService firestoreService,
    required NotificationProvider notificationProvider,
  }) async {
    if (_hasInitialized) return;

    try {
      _setInitializing(true);
      _clearError();

      // Wait a short moment to ensure Firebase Auth is initialized
      await Future.delayed(const Duration(milliseconds: 200));

      // Ensure FirestoreService is connected to ProfileProvider
      profileProvider.setFirestoreService(firestoreService);
      authController.setProfileProvider(profileProvider);

      // Check if user is already authenticated
      if (authController.isAuthenticated) {
        // Load user profile data from Firestore if authenticated
        await _loadUserProfile(profileProvider);
        
        // Initialize notification settings from SQLite
        await _loadNotificationSettings(notificationProvider);
      }

      _hasInitialized = true;
    } catch (e) {
      _setError('Failed to initialize app. Please restart the application.');
    } finally {
      _setInitializing(false);
    }
  }

  // Load user profile data with error handling
  Future<void> _loadUserProfile(ProfileProvider profileProvider) async {
    try {
      await profileProvider.refreshUserData();
    } catch (e) {
      // Log error but don't prevent app initialization
      _setError('Failed to load user profile. Some features may be unavailable.');
      // Even if Firestore fails, we can still use Firebase Auth data
    }
  }

  // Load notification settings with error handling
  Future<void> _loadNotificationSettings(NotificationProvider notificationProvider) async {
    try {
      await notificationProvider.refreshNotificationState();
    } catch (e) {
      // Log error but don't prevent app initialization
      _setError('Failed to load notification settings. Some features may be unavailable.');
    }
  }

  // Reset initialization state (useful for retrying)
  void resetInitialization() {
    _hasInitialized = false;
    _clearError();
    notifyListeners();
  }

  // Private helper methods
  void _setInitializing(bool isInitializing) {
    _isInitializing = isInitializing;
    notifyListeners();
  }

  void _setError(String error) {
    _initializationError = error;
    notifyListeners();
  }

  void _clearError() {
    _initializationError = null;
  }
}