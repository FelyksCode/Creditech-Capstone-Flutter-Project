import 'package:flutter/material.dart';
import 'dart:math';
import '../models/prediction_models.dart';
import '../services/database_service.dart';

class HistoryProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<TransactionPrediction>? _predictions;
  bool _isLoading = true;
  int _currentPage = 0;
  static const int _itemsPerPage = 10;
  String? _error;

  // Getters
  List<TransactionPrediction>? get predictions => _predictions;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  String? get error => _error;

  List<TransactionPrediction> getCurrentPageItems() {
    if (_predictions == null) return [];
    final start = _currentPage * _itemsPerPage;
    final end = start + _itemsPerPage;
    if (start >= _predictions!.length) return [];
    return _predictions!.sublist(start, min(end, _predictions!.length));
  }

  int get totalPages => _predictions == null ? 0 : ((_predictions!.length - 1) / _itemsPerPage).floor() + 1;

  bool get canGoBack => _currentPage > 0;
  bool get canGoForward => _predictions != null && _currentPage < ((_predictions!.length - 1) / _itemsPerPage).floor();

  void nextPage() {
    if (canGoForward) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (canGoBack) {
      _currentPage--;
      notifyListeners();
    }
  }

  Future<void> loadPredictions() async {
    // Use a microtask to ensure this runs after the current frame
    return Future.microtask(() async {
      _isLoading = true;
      _error = null;
      notifyListeners();

      try {
        final predictions = await _databaseService.getAllPredictions();
        _predictions = predictions;
        _currentPage = 0; // Reset to first page when reloading
      } catch (e) {
        _predictions = null;
        _error = e.toString();
        rethrow;
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  // Initial load method that's safer for use during widget initialization
  Future<void> initialLoad() async {
    try {
      final predictions = await _databaseService.getAllPredictions();
      _predictions = predictions;
      _currentPage = 0;
      _error = null;
    } catch (e) {
      _predictions = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
    }
    
    // Schedule notification for next frame to avoid build conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Clear error method
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Method to be called when new predictions are added from other parts of the app
  Future<void> refreshAfterNewPredictions() async {
    // Use the regular loadPredictions method but catch errors silently
    try {
      await loadPredictions();
    } catch (e) {
      debugPrint('Error refreshing history after new predictions: $e');
      // Don't rethrow the error since this is called from other parts of the app
    }
  }
}
