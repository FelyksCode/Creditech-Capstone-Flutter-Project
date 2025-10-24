import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:creditech_capstone_project/controller/auth_controller.dart';
import 'package:creditech_capstone_project/controller/auth_initialization_provider.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAuth();
    });
  }

  Future<void> _initializeAuth() async {
    final authInitProvider = Provider.of<AuthInitializationProvider>(context, listen: false);
    final authController = Provider.of<AuthController>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    await authInitProvider.initializeAuth(
      authController: authController,
      profileProvider: profileProvider,
      firestoreService: firestoreService,
      notificationProvider: notificationProvider,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthInitializationProvider>(
      builder: (context, authInitProvider, child) {
        // Show loading screen while initializing
        if (authInitProvider.isInitializing) {
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

        // Show error screen if initialization failed
        if (authInitProvider.initializationError != null) {
          return Scaffold(
            backgroundColor: const Color(0xFF1A1A1A),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authInitProvider.initializationError!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      authInitProvider.resetInitialization();
                      _initializeAuth();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4169E1),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
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
      },
    );
  }
}
