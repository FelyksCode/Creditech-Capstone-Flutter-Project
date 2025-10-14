import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:creditech_capstone_project/services/firestore_service.dart';

class ProfileProvider extends ChangeNotifier {
  FirestoreService? _firestoreService;

  // Profile information
  String _fullName = 'Puerto Rico';
  String _nickName = 'puerto_rico';
  String _email = 'youremail@domain.com';
  String _phone = '+01 234 567 89';
  String? _country;
  String? _photoURL;

  // Settings
  bool _generalNotificationOn = true;
  String _language = 'English';
  String _themeLabel = 'Light mode';

  // Notification settings
  bool _soundOn = false;
  bool _vibrateOn = true;
  bool _appUpdates = false;
  bool _billReminder = true;
  bool _promotion = true;
  bool _discountAvailable = false;
  bool _paymentRequest = false;
  bool _newService = false;
  bool _newTips = true;

  // Getters
  String get fullName => _fullName;
  String get nickName => _nickName;
  String get email => _email;
  String get phone => _phone;
  String? get country => _country;
  String? get photoURL => _photoURL;
  bool get generalNotificationOn => _generalNotificationOn;
  String get language => _language;
  String get themeLabel => _themeLabel;
  bool get soundOn => _soundOn;
  bool get vibrateOn => _vibrateOn;
  bool get appUpdates => _appUpdates;
  bool get billReminder => _billReminder;
  bool get promotion => _promotion;
  bool get discountAvailable => _discountAvailable;
  bool get paymentRequest => _paymentRequest;
  bool get newService => _newService;
  bool get newTips => _newTips;

  ProfileProvider() {
    // Initialize with Firebase user data if available
    _initializeUserData();
  }

  // Set the FirestoreService instance from Provider
  void setFirestoreService(FirestoreService firestoreService) {
    _firestoreService = firestoreService;
    // Re-initialize user data when FirestoreService is set
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _firestoreService != null) {
      try {
        // Try to load profile from Firestore first
        final profileData = await _firestoreService!.getUserProfile();
        if (profileData != null) {
          _loadProfileFromFirestore(profileData);
        } else {
          // If no Firestore data, use Firebase Auth data
          _loadProfileFromFirebaseAuth(user);
        }
      } catch (e) {
        // If Firestore fails, fallback to Firebase Auth data
        _loadProfileFromFirebaseAuth(user);
      }
      notifyListeners();
    } else if (user != null) {
      // If no Firestore service available, use Firebase Auth data
      _loadProfileFromFirebaseAuth(user);
      notifyListeners();
    }
  }

  void _loadProfileFromFirestore(Map<String, dynamic> data) {
    _fullName = data['fullName'] ?? 'User';
    _nickName = data['nickName'] ?? '';
    _email = data['email'] ?? '';
    _phone = data['phone'] ?? '';
    _country = data['country'] ?? 'Indonesia';
    _photoURL = data['photoURL'];
  }

  void _loadProfileFromFirebaseAuth(User user) {
    if (user.displayName != null) {
      _fullName = user.displayName!;
      // Extract first name for nickname
      List<String> nameParts = user.displayName!.split(' ');
      _nickName = nameParts.isNotEmpty ? nameParts.first : '';
    }
    if (user.email != null) {
      _email = user.email!;
    }
    if (user.phoneNumber != null) {
      _phone = user.phoneNumber!;
    }
    _photoURL = user.photoURL;
  }

  // Profile update methods
  Future<void> updateProfile({
    required String fullName,
    required String nickName,
    required String email,
    required String phone,
    String? country,
  }) async {
    _fullName = fullName;
    _nickName = nickName;
    _email = email;
    _phone = phone;
    if (country != null) _country = country;

    // Save to Firestore
    if (_firestoreService != null) {
      try {
        await _firestoreService!.saveUserProfile(
          fullName: fullName,
          nickName: nickName,
          email: email,
          phone: phone,
          country: _country,
        );
      } catch (e) {
        // Handle error silently for now, could add error state management
      }
    }

    notifyListeners();
  }

  void updateFullName(String fullName) {
    _fullName = fullName;
    notifyListeners();
  }

  void updateNickName(String nickName) {
    _nickName = nickName;
    notifyListeners();
  }

  void updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  void updateCountry(String? country) {
    _country = country;
    notifyListeners();
  }

  void updatePhotoURL(String? photoURL) {
    _photoURL = photoURL;
    notifyListeners();
  }

  // Save Google account data after Google sign-in (always saves/updates)
  Future<void> saveGoogleAccountData(User user) async {
    if (_firestoreService != null) {
      try {
        await _firestoreService!.saveGoogleAccountData(user);
        // Reload the profile data from Firestore
        await _initializeUserData();
      } catch (e) {
        // Fallback to local data update
        _loadProfileFromFirebaseAuth(user);
        notifyListeners();
      }
    } else {
      // Fallback to local data update
      _loadProfileFromFirebaseAuth(user);
      notifyListeners();
    }
  }

  // Save Google account data only if user is new (for login scenarios)
  Future<void> saveGoogleAccountDataIfNew(User user) async {
    if (_firestoreService != null) {
      try {
        // Check if user profile already exists
        final existingProfile = await _firestoreService!.getUserProfile();
        if (existingProfile == null) {
          // Only save if user doesn't exist yet
          await _firestoreService!.saveGoogleAccountData(user);
        }
        // Always reload the profile data from Firestore
        await _initializeUserData();
      } catch (e) {
        // Fallback to local data update
        _loadProfileFromFirebaseAuth(user);
        notifyListeners();
      }
    } else {
      // Fallback to local data update
      _loadProfileFromFirebaseAuth(user);
      notifyListeners();
    }
  }

  // Save email/password user data after email sign-in or registration
  Future<void> saveEmailPasswordUserData(User user) async {
    if (_firestoreService != null) {
      try {
        await _firestoreService!.saveEmailPasswordUserData(user);
        // Reload the profile data from Firestore
        await _initializeUserData();
      } catch (e) {
        // Fallback to local data update
        _loadProfileFromFirebaseAuth(user);
        notifyListeners();
      }
    } else {
      // Fallback to local data update
      _loadProfileFromFirebaseAuth(user);
      notifyListeners();
    }
  }

  // Settings update methods
  void updateGeneralNotification(bool value) {
    _generalNotificationOn = value;
    notifyListeners();
  }

  void updateLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  void updateTheme(String theme) {
    _themeLabel = theme;
    notifyListeners();
  }

  // Notification settings update methods
  void updateSoundNotification(bool value) {
    _soundOn = value;
    notifyListeners();
  }

  void updateVibrateNotification(bool value) {
    _vibrateOn = value;
    notifyListeners();
  }

  void updateAppUpdates(bool value) {
    _appUpdates = value;
    notifyListeners();
  }

  void updateBillReminder(bool value) {
    _billReminder = value;
    notifyListeners();
  }

  void updatePromotion(bool value) {
    _promotion = value;
    notifyListeners();
  }

  void updateDiscountAvailable(bool value) {
    _discountAvailable = value;
    notifyListeners();
  }

  void updatePaymentRequest(bool value) {
    _paymentRequest = value;
    notifyListeners();
  }

  void updateNewService(bool value) {
    _newService = value;
    notifyListeners();
  }

  void updateNewTips(bool value) {
    _newTips = value;
    notifyListeners();
  }

  // Reset to default values
  void resetProfile() {
    _fullName = 'Puerto Rico';
    _nickName = 'puerto_rico';
    _email = 'youremail@domain.com';
    _phone = '+01 234 567 89';
    _generalNotificationOn = true;
    _language = 'English';
    _themeLabel = 'Light mode';
    _soundOn = false;
    _vibrateOn = true;
    _appUpdates = false;
    _billReminder = true;
    _promotion = true;
    _discountAvailable = false;
    _paymentRequest = false;
    _newService = false;
    _newTips = true;
    notifyListeners();
  }
}
