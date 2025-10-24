import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:crypto/crypto.dart';

class CloudinaryService {
  static const String _baseUrl = 'https://api.cloudinary.com/v1_1';
  static const String _cloudName = 'dvhn9lxls';

  static String get _apiKey => dotenv.env['API_KEY'] ?? '';
  static String get _apiSecret => dotenv.env['API_SECRET'] ?? '';

  static Future<String?> uploadImage(File imageFile, {String? userId}) async {
    try {
      if (!await imageFile.exists()) {
        return null;
      }

      final fileSize = await imageFile.length();
      if (fileSize > 10 * 1024 * 1024) {
        return null;
      }

      final url = Uri.parse('$_baseUrl/$_cloudName/image/upload');
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final publicId = 'profile_${userId ?? 'user'}_$timestamp';

      // transformation must be included in signature
      final transformation = 'c_fill,w_300,h_300,q_auto';

      final signatureParams = {
        'folder': 'profile_photos',
        'public_id': publicId,
        'timestamp': timestamp.toString(),
        'transformation': transformation,
      };

      final signature = _generateSignature(signatureParams, _apiSecret);

      final request = http.MultipartRequest('POST', url);
      final fileBytes = await imageFile.readAsBytes();

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: 'profile_image.jpg',
      ));

      request.fields.addAll({
        'api_key': _apiKey,
        'timestamp': timestamp.toString(),
        'signature': signature,
        'public_id': publicId,
        'folder': 'profile_photos',
        'transformation': transformation,
      });


      final response = await request.send();
      final responseBody = await response.stream.bytesToString();


      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody);
        return jsonResponse['secure_url'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static String _generateSignature(Map<String, dynamic> params, String apiSecret) {
    final sortedParams = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    final paramString = sortedParams.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');

    final stringToSign = '$paramString$apiSecret';
    final bytes = utf8.encode(stringToSign);
    final digest = sha1.convert(bytes);
    return digest.toString();
  }

  static String _buildStringToSign(Map<String, dynamic> params) {
    final sortedParams = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return sortedParams.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
  }

  static Future<bool> deleteImage(String publicId) async {
    try {
      final url = Uri.parse('$_baseUrl/$_cloudName/image/destroy');
      final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final params = {
        'public_id': publicId,
        'timestamp': timestamp.toString(),
      };
      final signature = _generateSignature(params, _apiSecret);

      final response = await http.post(url, body: {
        'api_key': _apiKey,
        'timestamp': timestamp.toString(),
        'signature': signature,
        'public_id': publicId,
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['result'] == 'ok';
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
