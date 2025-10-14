import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's profile collection reference
  CollectionReference get _userProfiles => _firestore.collection('users');

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Save or update user profile to Firestore
  Future<void> saveUserProfile({
    required String fullName,
    required String nickName,
    required String email,
    required String phone,
    String? country,
  }) async {
    if (currentUserId == null) return;

    try {
      await _userProfiles.doc(currentUserId).set({
        'uid': currentUserId,
        'fullName': fullName,
        'nickName': nickName,
        'email': email,
        'phone': phone,
        'country': country,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save profile: $e');
    }
  }

  // Get user profile from Firestore
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUserId == null) return null;

    try {
      DocumentSnapshot doc = await _userProfiles.doc(currentUserId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  // Save Google account data to Firestore
  Future<void> saveGoogleAccountData(User user) async {
    // Use user.uid directly instead of currentUserId to avoid timing issues
    final userId = user.uid;

    if (userId.isEmpty) {
      throw Exception('User UID is empty');
    }

    try {
      // Extract first name from display name
      String firstName = '';
      if (user.displayName != null) {
        List<String> nameParts = user.displayName!.split(' ');
        firstName = nameParts.isNotEmpty ? nameParts.first : '';
      }

      Map<String, dynamic> profileData = {
        'uid': userId,
        'fullName': user.displayName ?? '',
        'nickName': firstName,
        'email': user.email ?? '',
        'phone': user.phoneNumber ?? '+62',
        'photoURL': user.photoURL,
        'provider': 'google',
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Only set createdAt if this is a new document
      DocumentSnapshot existingDoc = await _userProfiles.doc(userId).get();
      if (!existingDoc.exists) {
        profileData['createdAt'] = FieldValue.serverTimestamp();
        profileData['country'] = "Indonesia";

        // For new users, save all profile data
        await _userProfiles
            .doc(userId)
            .set(profileData, SetOptions(merge: true));
      } else {
        // For existing users, only update specific fields to avoid overwriting custom profile data
        Map<String, dynamic> updateData = {
          'photoURL': user.photoURL,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        // Only update email if it's not already set or if it's different
        final existingData = existingDoc.data() as Map<String, dynamic>?;
        if (existingData != null) {
          if (existingData['email'] == null ||
              existingData['email'].toString().isEmpty) {
            updateData['email'] = user.email ?? '';
          }
        }

        await _userProfiles.doc(userId).update(updateData);
      }
    } catch (e) {
      throw Exception('Failed to save Google account data: $e');
    }
  }

  // Save email/password user data to Firestore
  Future<void> saveEmailPasswordUserData(User user) async {
    // Use user.uid directly instead of currentUserId to avoid timing issues
    final userId = user.uid;

    if (userId.isEmpty) {
      throw Exception('User UID is empty');
    }

    try {
      // Extract username from email (part before '@')
      String emailUsername = '';
      if (user.email != null) {
        emailUsername = user.email!.split('@').first;
      }

      Map<String, dynamic> profileData = {
        'uid': userId,
        'fullName': emailUsername,
        'nickName': emailUsername,
        'email': user.email ?? '',
        'phone': '',
        'photoURL': null,
        'provider': 'email',
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Only set createdAt if this is a new document
      DocumentSnapshot existingDoc = await _userProfiles.doc(userId).get();
      if (!existingDoc.exists) {
        profileData['createdAt'] = FieldValue.serverTimestamp();
        profileData['country'] = null;

        // For new users, save all profile data
        await _userProfiles
            .doc(userId)
            .set(profileData, SetOptions(merge: true));
      } else {
        // For existing users, only update the timestamp to avoid overwriting custom profile data
        Map<String, dynamic> updateData = {
          'updatedAt': FieldValue.serverTimestamp(),
        };

        await _userProfiles.doc(userId).update(updateData);
      }
    } catch (e) {
      throw Exception('Failed to save email/password user data: $e');
    }
  }

  // Update specific profile fields
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (currentUserId == null) return;

    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _userProfiles.doc(currentUserId).update(updates);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Delete user profile
  Future<void> deleteUserProfile() async {
    if (currentUserId == null) return;

    try {
      await _userProfiles.doc(currentUserId).delete();
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  // Listen to profile changes
  Stream<Map<String, dynamic>?> listenToUserProfile() {
    if (currentUserId == null) {
      return Stream.value(null);
    }

    return _userProfiles.doc(currentUserId).snapshots().map((doc) {
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    });
  }
}
