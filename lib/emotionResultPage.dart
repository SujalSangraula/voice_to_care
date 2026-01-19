import 'package:flutter/material.dart';

class EmotionResultPage extends StatelessWidget {
  final String emotion;
  final double confidence;

  const EmotionResultPage({
    super.key,
    required this.emotion,
    required this.confidence,
  });

  String _emotionEmoji(String emotion) {
    switch (emotion) {
      case 'happy':
        return 'You seem to be HAPPY nice to hear that!!!😊';
      case 'sad':
        return 'You seem SAD what can I do to help you?😢';
      case 'angry':
        return 'Relax you are ANGRY right now stak calm..😠';
      default:
        return 'NEURAL BOARING😐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detected Emotion"),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.deepPurple[50],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _emotionEmoji(emotion),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              emotion.toUpperCase(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Confidence: ${(confidence * 100).toStringAsFixed(1)}%",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
