import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class EmotionApiService {
  static const String baseUrl = "http://192.168.1.68:8000";
  // change to laptop IP for real device

  static Future<Map<String, dynamic>> analyzeAudio(String filePath) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/predict-emotion"),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'audio',
        filePath,
        filename: basename(filePath),
        contentType: http.MediaType('audio', 'mp4'),
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      return jsonDecode(body);
    } else {
      throw Exception("Failed to detect emotion");
    }
  }
}
