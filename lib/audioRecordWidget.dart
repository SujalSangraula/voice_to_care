import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderWidget extends StatefulWidget {
  const AudioRecorderWidget({super.key});

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String _filePath = '';
  int _seconds = 0;
  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _seconds = 0;
  }

  String get _formattedTime {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _startRecording() async {
    if (!await Permission.microphone.request().isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission denied')),
        );
      }
      return;
    }


    Directory downloadsDir = Directory('/storage/emulated/0/Download/VoiceToCare');
    if (!downloadsDir.existsSync()) {
      downloadsDir.createSync(recursive: true);
    }

    String path =
        '${downloadsDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    final config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
    );

    await _recorder.start(config, path: path);

    setState(() {
      _isRecording = true;
      _filePath = path;
    });

    _startTimer();
  }

  Future<void> _stopRecording() async {
    String? path = await _recorder.stop();

    _stopTimer();

    setState(() {
      _isRecording = false;
    });

    if (mounted) {
      Navigator.of(context).pop(path ?? _filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recording saved at: ${path ?? _filePath}')),
      );
    }
  }

  @override
  void dispose() {
    _recorder.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isRecording ? 'Recording...' : 'Tap the button to record',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 10),
          if (_isRecording)
            Text(
              _formattedTime,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
              ),
            ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _isRecording ? _stopRecording : _startRecording,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _isRecording ? Colors.red : Colors.deepPurple,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _isRecording
                        ? Colors.redAccent.withOpacity(0.5)
                        : Colors.deepPurpleAccent.withOpacity(0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _isRecording
                ? 'Tap the button to stop recording'
                : 'Your recording will be saved in Downloads/VoiceToCare',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
