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
        return 'Relax you are ANGRY right now stay calm..😠';
      default:
        return 'NEURAL BORING😐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detected Emotion"),centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                height: 250,
                width: 350,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      _emotionEmoji(emotion),
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 30,),
                    Text(
                      emotion.toUpperCase(),
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      "Confidence: ${(confidence*100).toStringAsFixed(1)}%",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              height: 550,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(emotion.toUpperCase(),style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),

                ],
              ),
            ),
            const SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
}
