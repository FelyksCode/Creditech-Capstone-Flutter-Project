import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/prediction_models.dart';

class UploadService {
  static String baseUrl = dotenv.env['ML_API_URL'] ?? '';


  Future<Map<String, dynamic>> uploadCsvFile(File file) async {
    
    try {
      final uri = Uri.parse('$baseUrl/predict');
      final request = http.MultipartRequest('POST', uri);

      final fileStream = http.ByteStream(file.openRead());
      final fileLength = await file.length();

      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: path.basename(file.path),
      );

      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prediction = PredictionResult.fromJson(data);
        return {
          'success': true,
          'data': prediction,
        };
      } else {
        return {
          'success': false,
          'message': 'Upload failed with status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error uploading file: $e',
      };
    }
  }


}