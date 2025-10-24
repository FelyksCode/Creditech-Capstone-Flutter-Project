import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import '../services/local_notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  
  bool _isNotificationEnabled = true;
  bool _isLoading = false;
  String? _error;

  // Getters
  bool get isNotificationEnabled => _isNotificationEnabled;
  bool get isLoading => _isLoading;
  String? get error => _error;

  NotificationProvider() {
    _initializeNotificationState();
    _initializeNotificationService();
  }

  // Initialize notification service
  Future<void> _initializeNotificationService() async {
    await LocalNotificationService.initialize();
    await LocalNotificationService.requestPermissions();
  }

  // Initialize notification state from database
  Future<void> _initializeNotificationState() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      _setLoading(true);
      _clearError();

      final savedSetting = await _databaseService.getNotificationSetting(user.uid);
      
      if (savedSetting != null) {
        _isNotificationEnabled = savedSetting;
      } else {
        // First time user, save default setting
        await _databaseService.saveNotificationSetting(
          userId: user.uid,
          isEnabled: _isNotificationEnabled,
        );
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load notification settings: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Toggle notification setting
  Future<void> toggleNotification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _setError('User not authenticated');
      return;
    }

    try {
      _setLoading(true);
      _clearError();

      final newValue = !_isNotificationEnabled;
      
      // Update local state
      _isNotificationEnabled = newValue;
      notifyListeners();

      // Save to database
      await _databaseService.saveNotificationSetting(
        userId: user.uid,
        isEnabled: newValue,
      );

      // Manage background notifications
      await _manageBackgroundNotifications(newValue);

    } catch (e) {
      // Revert local state on error
      _isNotificationEnabled = !_isNotificationEnabled;
      _setError('Failed to save notification settings: $e');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Set notification state directly
  Future<void> setNotificationEnabled(bool enabled) async {
    if (_isNotificationEnabled == enabled) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _setError('User not authenticated');
      return;
    }

    try {
      _setLoading(true);
      _clearError();

      // Update local state
      _isNotificationEnabled = enabled;
      notifyListeners();

      // Save to database
      await _databaseService.saveNotificationSetting(
        userId: user.uid,
        isEnabled: enabled,
      );

      // Manage background notifications
      await _manageBackgroundNotifications(enabled);

    } catch (e) {
      // Revert local state on error
      _isNotificationEnabled = !enabled;
      _setError('Failed to save notification settings');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Refresh notification state from database
  Future<void> refreshNotificationState() async {
    await _initializeNotificationState();
    
    // Also manage notifications based on current state
    if (_isNotificationEnabled) {
      await _manageBackgroundNotifications(true);
    }
  }

  // Manage background notifications based on setting
  Future<void> _manageBackgroundNotifications(bool enabled) async {
    try {
      if (enabled) {
        // Schedule periodic notifications
        await LocalNotificationService.schedulePeriodicNotifications();
      } else {
        // Cancel all notifications
        await LocalNotificationService.cancelAllNotifications();
      }
    } catch (e) {
      // Surface error to UI and log for debugging
      _setError('Error managing background notifications: $e');
    }
  }

  // Clear user settings on logout
  Future<void> clearUserSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _databaseService.deleteUserSettings(user.uid);
      } catch (e) {
        _setError('Error clearing user settings');
      }
    }
    
    // Cancel all notifications on logout
    await LocalNotificationService.cancelAllNotifications();
    
    // Reset to default state
    _isNotificationEnabled = true;
    _clearError();
    notifyListeners();
  }

  // Reset to default when user logs in with different account
  void resetToDefault() {
    _isNotificationEnabled = true;
    _clearError();
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Show test notification
  Future<void> showTestNotification() async {
    if (_isNotificationEnabled) {
      await LocalNotificationService.showTestNotification();
    }
  }

  // Get pending notifications count (for debugging)
  Future<int> getPendingNotificationsCount() async {
    try {
      final pending = await LocalNotificationService.getPendingNotifications();
      return pending.length;
    } catch (e) {
      _setError('Error getting pending notifications');
      return 0;
    }
  }

  // For debugging - get all settings
  Future<List<Map<String, dynamic>>> getAllSettings() async {
    try {
      return await _databaseService.getAllSettings();
    } catch (e) {
      _setError('Error getting all settings');
      return [];
    }
  }
}