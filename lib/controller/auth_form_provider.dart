import 'package:flutter/material.dart';

class AuthFormProvider extends ChangeNotifier {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  bool get isPasswordHidden => _obscurePassword;
  bool get isConfirmPasswordHidden => _obscureConfirmPassword;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // Methods to update state
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}