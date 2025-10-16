import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:creditech_capstone_project/controller/auth_controller.dart';
import 'package:creditech_capstone_project/controller/profile_provider.dart';
import 'package:creditech_capstone_project/controller/notification_provider.dart';
import 'package:creditech_capstone_project/services/firestore_service.dart';
import 'package:creditech_capstone_project/ui/pages/auth/login_page.dart';
import 'package:creditech_capstone_project/ui/pages/main_page/main_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    // Wait a short moment to ensure Firebase Auth is initialized
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (mounted) {
      final authController = Provider.of<AuthController>(context, listen: false);
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final firestoreService = Provider.of<FirestoreService>(context, listen: false);
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      
      // Ensure FirestoreService is connected to ProfileProvider
      profileProvider.setFirestoreService(firestoreService);
      authController.setProfileProvider(profileProvider);
      
      // Check if user is already authenticated
      if (authController.isAuthenticated) {
        // Load user profile data from Firestore if authenticated
        try {
          print('User is authenticated, loading profile data from Firestore...');
          await profileProvider.refreshUserData();
          print('Profile data loaded successfully');
          
          // Initialize notification settings from SQLite
          print('Initializing notification settings from SQLite...');
          await notificationProvider.refreshNotificationState();
          print('Notification settings loaded successfully');
        } catch (e) {
          print('Error loading user data from Firestore: $e');
          // Even if Firestore fails, we can still use Firebase Auth data
        }
      }
      
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while initializing
    if (_isInitializing) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A1A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4169E1)),
              ),
              SizedBox(height: 16),
              Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while waiting for auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1A1A1A),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4169E1)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Checking authentication...',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // User is logged in
        if (snapshot.hasData && snapshot.data != null) {
          return const MainPage();
        }

        // User is not logged in
        return const LoginLandingPage();
      },
    );
  }
}
