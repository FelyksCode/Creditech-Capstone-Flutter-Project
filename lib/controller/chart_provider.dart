import 'package:flutter/material.dart';
import 'package:creditech_capstone_project/services/database_service.dart';
import 'package:creditech_capstone_project/models/prediction_models.dart';

class ChartProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<TransactionPrediction>? _thisMonthPredictions;
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  List<TransactionPrediction>? get thisMonthPredictions => _thisMonthPredictions;

  double get fraudRatio {
    if (_thisMonthPredictions == null || _thisMonthPredictions!.isEmpty) return 0.0;
    final fraudCount = _thisMonthPredictions!.where((p) => p.isFraud == 1).length;
    return fraudCount / _thisMonthPredictions!.length;
  }

  int get totalCount => _thisMonthPredictions?.length ?? 0;
  int get fraudCount => _thisMonthPredictions?.where((p) => p.isFraud == 1).length ?? 0;
  int get safeCount => totalCount - fraudCount;

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final allPredictions = await _databaseService.getAllPredictions();
      final now = DateTime.now();
      _thisMonthPredictions = allPredictions.where((prediction) {
        if (prediction.timestamp == null || prediction.timestamp!.isEmpty) return false;
        final predictionDate = DateTime.parse(prediction.timestamp!);
        return predictionDate.year == now.year && predictionDate.month == now.month;
      }).toList();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _thisMonthPredictions = null;
      _isLoading = false;
      notifyListeners();
    }
  }
}