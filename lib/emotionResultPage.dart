import 'package:flutter/material.dart';

class EmotionResultPage extends StatelessWidget {
  final String emotion;
  final double confidence;
  final List<Map<String, dynamic>> emotionList;
  final List<Map<String, dynamic>> segments;
  final List<String> segmentEmotions;
  final List<String> uniqueEmotions;
  final List<Map<String, dynamic>> emotionsWithConfidence;
  final List<Map<String, dynamic>> sortedEmotions;
  final String transcript;
  final String ragResponse;
  final String ragMode;
  final bool sessionActive;

  const EmotionResultPage({
    super.key,
    required this.emotion,
    required this.confidence,
    required this.emotionList,
    required this.segments,
    required this.segmentEmotions,
    required this.uniqueEmotions,
    required this.emotionsWithConfidence,
    required this.sortedEmotions,
    required this.transcript,
    required this.ragResponse,
    required this.ragMode,
    required this.sessionActive,
  });

  String _emoji(String e) {
    switch (e.toLowerCase()) {
      case 'happy':    return '😊';
      case 'sad':      return '😢';
      case 'angry':    return '😠';
      case 'fear':     return '😨';
      case 'disgust':  return '🤢';
      case 'surprise': return '😲';
      case 'neutral':  return '😐';
      default:         return '🎙️';
    }
  }

  Color _color(String e) {
    switch (e.toLowerCase()) {
      case 'happy':    return Colors.green;
      case 'sad':      return Colors.blue;
      case 'angry':    return Colors.red;
      case 'fear':     return Colors.purple;
      case 'disgust':  return Colors.lightGreen;
      case 'surprise': return Colors.orange;
      case 'neutral':  return Colors.grey;
      default:         return Colors.deepPurple;
    }
  }

  String _message(String e) {
    switch (e.toLowerCase()) {
      case 'happy':    return 'You seem HAPPY, nice to hear that! 😊';
      case 'sad':      return 'You seem SAD, what can I do to help? 😢';
      case 'angry':    return 'You are ANGRY, stay calm.. 😠';
      case 'fear':     return 'You seem FEARFUL, you are safe here 😨';
      case 'disgust':  return 'You seem DISGUSTED, want to talk? 🤢';
      case 'surprise': return 'You seem SURPRISED! 😲';
      case 'neutral':  return 'You seem NEUTRAL, just a regular day 😐';
      default:         return 'Emotion: ${e.toUpperCase()}';
    }
  }

  Color _modeColor(String mode) {
    switch (mode.toLowerCase()) {
      case 'guiding':   return Colors.deepPurple;
      case 'listening': return Colors.teal;
      case 'asking':    return Colors.orange;
      case 'crisis':    return Colors.red;
      default:          return Colors.grey;
    }
  }

  IconData _modeIcon(String mode) {
    switch (mode.toLowerCase()) {
      case 'guiding':   return Icons.lightbulb_outline;
      case 'listening': return Icons.hearing;
      case 'asking':    return Icons.help_outline;
      case 'crisis':    return Icons.warning_amber_rounded;
      default:          return Icons.chat_bubble_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Analysis Result",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Emotion card ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _color(emotion).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _color(emotion).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(_emoji(emotion),
                      style: const TextStyle(fontSize: 60)),
                  const SizedBox(height: 12),
                  Text(
                    emotion.toUpperCase(),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _color(emotion),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _message(emotion),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Confidence: ${(confidence * 100).toStringAsFixed(1)}%",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _color(emotion),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Transcript card ───────────────────────────────────────────
            if (transcript.isNotEmpty) ...[
              const Text(
                "🎙️ What You Said",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.mic,
                          color: Colors.blue, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        transcript,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── RAG Therapist Response ────────────────────────────────────
            if (ragResponse.isNotEmpty) ...[
              Row(
                children: [
                  const Text(
                    "🧠 Therapist Response",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _modeColor(ragMode).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                          color: _modeColor(ragMode).withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_modeIcon(ragMode),
                            size: 12, color: _modeColor(ragMode)),
                        const SizedBox(width: 4),
                        Text(
                          ragMode.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _modeColor(ragMode),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ragMode.toLowerCase() == 'crisis'
                      ? Colors.red.shade50
                      : Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ragMode.toLowerCase() == 'crisis'
                        ? Colors.red.shade200
                        : Colors.deepPurple.shade100,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _modeIcon(ragMode),
                          color: _modeColor(ragMode),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          ragMode.toLowerCase() == 'crisis'
                              ? 'Crisis Support'
                              : ragMode.toLowerCase() == 'guiding'
                              ? 'Therapeutic Guidance'
                              : ragMode.toLowerCase() == 'asking'
                              ? 'Understanding You Better'
                              : 'Listening',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: _modeColor(ragMode),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ragResponse,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: ragMode.toLowerCase() == 'crisis'
                            ? Colors.red.shade800
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}