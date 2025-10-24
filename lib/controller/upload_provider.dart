import 'dart:io';
import 'package:flutter/foundation.dart';
import '../services/upload_service.dart';
import '../services/database_service.dart';
import '../models/upload_models.dart';
import '../models/prediction_models.dart';

class UploadProvider with ChangeNotifier {
  final UploadService _uploadService = UploadService();
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;
  String? _error;
  List<UploadFileStatus> _uploadedFiles = [];
  PredictionResult? _predictionResult;
  bool _isMinimized = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<UploadFileStatus> get uploadedFiles => _uploadedFiles;
  PredictionResult? get predictionResult => _predictionResult;
  bool get isMinimized => _isMinimized;

  void setMinimized(bool value) {
    _isMinimized = value;
    notifyListeners();
  }

  Future<void> uploadFile(File file) async {
    try {
      // Only allow one file at a time
      if (_uploadedFiles.isNotEmpty) {
        _error = 'Please remove the current file before uploading a new one.';
        notifyListeners();
        return;
      }

      _isLoading = true;
      _error = null;
      notifyListeners();

      // Create a new upload status
      final uploadStatus = UploadFileStatus(
        file: file,
        fileName: file.path.split('/').last,
        status: UploadStatus.uploading,
        progress: 0.0,
      );
      
      _uploadedFiles = [uploadStatus]; // Replace any existing files
      notifyListeners();

      // Upload the file and get prediction
      final result = await _uploadService.uploadCsvFile(file);

      // Update the status based on the result
      final index = _uploadedFiles.indexWhere(
        (status) => status.fileName == uploadStatus.fileName,
      );
      
      if (index != -1) {
        _uploadedFiles[index] = uploadStatus.copyWith(
          status: result['success'] ? UploadStatus.completed : UploadStatus.failed,
          progress: 1.0,
        );
      }

      if (!result['success']) {
        _error = result['message'] as String;
        _predictionResult = null; // Clear prediction result on error
        notifyListeners();
      } else {
        // Store prediction result
        _predictionResult = result['data'] as PredictionResult;
        
        // Save predictions to local database
        for (var prediction in _predictionResult!.predictions) {
          await _databaseService.savePrediction(prediction);
        }
        
        notifyListeners(); // Notify listeners when prediction result is set
      }
    } catch (e) {
      _error = 'Failed to upload file: $e';
      _predictionResult = null; // Clear prediction result on error
      
      // Update file status to failed
      final index = _uploadedFiles.indexWhere(
        (status) => status.fileName == file.path.split('/').last,
      );
      if (index != -1) {
        _uploadedFiles[index] = _uploadedFiles[index].copyWith(
          status: UploadStatus.failed,
          progress: 0.0,
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeUploadedFile(int index) {
    if (index >= 0 && index < _uploadedFiles.length) {
      _uploadedFiles.removeAt(index);
      _predictionResult = null; // Clear prediction result when file is removed
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<List<TransactionPrediction>> loadStoredPredictions() async {
    return await _databaseService.getAllPredictions();
  }

  // Method to get the count of predictions saved in the last upload
  int getLastUploadPredictionCount() {
    return _predictionResult?.predictions.length ?? 0;
  }

  // Method to check if there are new predictions from the last upload
  bool hasNewPredictions() {
    return _predictionResult != null && _predictionResult!.predictions.isNotEmpty;
  }

  void addFile(File file) {
    final uploadStatus = UploadFileStatus(
      file: file,
      fileName: file.path.split('/').last,
      status: UploadStatus.completed,
      progress: 1.0,
    );
    if (!_uploadedFiles.any((status) => status.fileName == uploadStatus.fileName)) {
      _uploadedFiles.add(uploadStatus);
      notifyListeners();
    }
  }

}