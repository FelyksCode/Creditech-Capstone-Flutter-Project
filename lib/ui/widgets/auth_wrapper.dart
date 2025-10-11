import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creditech_capstone_project/controller/auth_controller.dart';
import 'package:creditech_capstone_project/ui/pages/auth/login_page.dart';
import 'package:creditech_capstone_project/ui/pages/main_page/main_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        // Show login page if not authenticated
        if (!authController.isAuthenticated) {
          return const LoginLandingPage();
        }
        
        // Show main page if authenticated
        return const MainPage();
      },
    );
  }
}