import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class EmotionApiService {
  static const String baseUrl = "http://192.168.1.81:8000";

  //unique session ID
  static String sessionId = "user-session-1";

  //analyze audio
  static Future<Map<String, dynamic>> analyzeAudio(String filePath) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/predict"),
    );

    // Send session ID so RAG remembers conversation history
    request.headers['session-id'] = sessionId;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        filePath,
        filename: basename(filePath),
        contentType: http.MediaType('audio', 'wav'),
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      print("=== API RESPONSE ===");
      print(body);
      print("===================");

      final data = jsonDecode(body);

      final String emotion = data['emotion'];
      final Map<String, dynamic> probabilities =
      Map<String, dynamic>.from(data['probabilities']);

      // all 7 emotions
      final List<Map<String, dynamic>> emotionList = probabilities.entries
          .map((e) => {
        'emotion'    : e.key,
        'probability': e.value as double,
      })
          .toList()
        ..sort((a, b) => (b['probability'] as double)
            .compareTo(a['probability'] as double));

      // segment emotions for RAG
      final List<String> segmentEmotions =
      List<String>.from(data['segment_emotions'] ?? [emotion]);
      final List<String> uniqueEmotions =
      List<String>.from(data['unique_emotions'] ?? [emotion]);
      final List<Map<String, dynamic>> emotionsWithConfidence =
      List<Map<String, dynamic>>.from(
          (data['emotions_with_confidence'] ?? [])
              .map((e) => Map<String, dynamic>.from(e)));
      final List<Map<String, dynamic>> sortedEmotions =
      List<Map<String, dynamic>>.from(
          (data['sorted_emotions'] ?? [])
              .map((e) => Map<String, dynamic>.from(e)));

      // RAG response
      final Map<String, dynamic> rag =
      Map<String, dynamic>.from(data['rag'] ?? {
        'response': 'Tell me more about how you are feeling.',
        'mode'    : 'listening',
      });

      print("=== PARSED DATA ===");
      print("Top emotion  : $emotion");
      print("Transcript   : ${data['transcript']}");
      print("RAG Mode     : ${rag['mode']}");
      print("RAG Response : ${rag['response']}");
      print("===================");

      return {
        // Emotion results
        'emotion'               : emotion,
        'confidence'            : probabilities[emotion] as double,
        'probabilities'         : probabilities,
        'duration_sec'          : data['duration_sec'],
        'num_segments'          : data['num_segments'],

        // UI display
        'emotionList'           : emotionList,
        'segments'              : List<Map<String, dynamic>>.from(
            (data['segments'] ?? []).map((e) => Map<String, dynamic>.from(e))),

        // RAG arrays
        'segmentEmotions'       : segmentEmotions,
        'uniqueEmotions'        : uniqueEmotions,
        'emotionsWithConfidence': emotionsWithConfidence,
        'sortedEmotions'        : sortedEmotions,

        // Transcription
        'transcript'            : data['transcript'] ?? '',

        // RAG mental health response
        'ragResponse'           : rag['response'] ?? '',
        'ragMode'               : rag['mode'] ?? 'listening',
        'ragTurn'               : rag['turn'] ?? 1,
        'ragAnalysis'           : rag['analysis'] ?? {},
        'sessionActive'         : rag['session_active'] ?? true,
      };
    } else {
      final body = await response.stream.bytesToString();
      throw Exception("Failed: ${response.statusCode} - $body");
    }
  }

  static Future<void> startNewConversation() async {
    try {
      await http.post(
        Uri.parse("$baseUrl/new-conversation"),
        headers: {'session-id': sessionId},
      );
      print("New conversation started");
    } catch (e) {
      print("Error: $e");
    }
  }
}