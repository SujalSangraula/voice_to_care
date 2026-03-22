import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'emotionApiService.dart';

class ChatMessage {
  final String type;
  final String text;
  final String? emotion;
  final String? emoji;
  final String? ragMode;
  final DateTime time;

  ChatMessage({
    required this.type,
    required this.text,
    this.emotion,
    this.emoji,
    this.ragMode,
    required this.time,
  });
}


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final AudioRecorder _recorder     = AudioRecorder();
  final ScrollController _scroll   = ScrollController();
  final List<ChatMessage> _messages = [];

  bool _isRecording  = false;
  bool _isLoading    = false;
  int  _seconds      = 0;
  Timer? _timer;
  String _filePath   = '';

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _seconds = 0;
  }

  String get _formattedTime {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }


  Future<void> _startRecording() async {
    if (!await Permission.microphone.request().isGranted) {
      _showSnack('Microphone permission denied');
      return;
    }

    Directory dir = Directory('/storage/emulated/0/Download/VoiceToCare');
    if (!dir.existsSync()) dir.createSync(recursive: true);

    String path = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.start(
      RecordConfig(
        encoder    : AudioEncoder.wav,
        sampleRate : 16000,
        numChannels: 1,
      ),
      path: path,
    );

    setState(() {
      _isRecording = true;
      _filePath    = path;
    });
    _startTimer();
  }

  Future<void> _stopRecording() async {
    String? path = await _recorder.stop();
    _stopTimer();
    setState(() => _isRecording = false);

    if (path != null || _filePath.isNotEmpty) {
      await _sendAudio(path ?? _filePath);
    }
  }


  Future<void> _sendAudio(String filePath) async {
    setState(() => _isLoading = true);

    try {
      final result = await EmotionApiService.analyzeAudio(filePath);

      final String emotion    = result['emotion'] ?? 'neutral';
      final String transcript = result['transcript'] ?? '';
      final String ragResponse = result['ragResponse'] ?? '';
      final String ragMode    = result['ragMode'] ?? 'listening';

      setState(() {
        //user ko message
        if (transcript.isNotEmpty) {
          _messages.add(ChatMessage(
            type   : 'user',
            text   : transcript,
            emotion: emotion,
            emoji  : _emoji(emotion),
            time   : DateTime.now(),
          ));
        }

        // rag ko messsage
        if (ragResponse.isNotEmpty) {
          _messages.add(ChatMessage(
            type   : 'assistant',
            text   : ragResponse,
            ragMode: ragMode,
            time   : DateTime.now(),
          ));
        }
      });

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    } catch (e) {
      _showSnack('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }


  Future<void> _newConversation() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Conversation'),
        content: const Text(
            'This will clear all chat history and start fresh. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Start Fresh',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await EmotionApiService.startNewConversation();
      setState(() => _messages.clear());
      _showSnack('New conversation started!');
    }
  }


  void _scrollToBottom() {
    if (_scroll.hasClients) {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

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

  String _modeLabel(String mode) {
    switch (mode.toLowerCase()) {
      case 'guiding':   return 'Guidance';
      case 'listening': return 'Listening';
      case 'asking':    return 'Understanding You Better';
      case 'crisis':    return 'Crisis Support';
      default:          return 'Response';
    }
  }

  @override
  void dispose() {
    _recorder.dispose();
    _timer?.cancel();
    _scroll.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voice2Care',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              'Mental Health Assistant',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          // New conversation button
          TextButton.icon(
            onPressed: _messages.isEmpty ? null : _newConversation,
            icon: const Icon(Icons.add_circle_outline,
                size: 18, color: Colors.deepPurple),
            label: const Text(
              'New Chat',
              style: TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          _buildRecordingBar(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic, size: 48, color: Colors.deepPurple),
          ),
          const SizedBox(height: 20),
          const Text(
            'Start talking',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the mic button and share\nhow you are feeling today',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage msg) {
    final bool isUser = msg.type == 'user';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.psychology,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [

                if (!isUser && msg.ragMode != null) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_modeIcon(msg.ragMode!),
                          size: 12,
                          color: _modeColor(msg.ragMode!)),
                      const SizedBox(width: 4),
                      Text(
                        _modeLabel(msg.ragMode!),
                        style: TextStyle(
                          fontSize: 11,
                          color: _modeColor(msg.ragMode!),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],

                if (isUser && msg.emotion != null) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(msg.emoji ?? '🎙️',
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        msg.emotion!.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],

                // Bubble
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Colors.deepPurple
                        : msg.ragMode?.toLowerCase() == 'crisis'
                        ? Colors.red.shade50
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft    : const Radius.circular(18),
                      topRight   : const Radius.circular(18),
                      bottomLeft : Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    border: !isUser
                        ? Border.all(
                        color: msg.ragMode?.toLowerCase() == 'crisis'
                            ? Colors.red.shade200
                            : Colors.grey.shade200)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: isUser
                          ? Colors.white
                          : msg.ragMode?.toLowerCase() == 'crisis'
                          ? Colors.red.shade800
                          : Colors.black87,
                    ),
                  ),
                ),

                // Time
                const SizedBox(height: 4),
                Text(
                  '${msg.time.hour.toString().padLeft(2, '0')}:${msg.time.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),

          // User avatar
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person,
                  color: Colors.deepPurple, size: 20),
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.psychology,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(0),
                const SizedBox(width: 4),
                _dot(200),
                const SizedBox(width: 4),
                _dot(400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Container(
          width: 8, height: 8,
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }


  Widget _buildRecordingBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isRecording) ...[
            const Icon(Icons.circle, color: Colors.red, size: 12),
            const SizedBox(width: 8),
            Text(
              _formattedTime,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 20),
          ],
          GestureDetector(
            onTap: _isLoading
                ? null
                : (_isRecording ? _stopRecording : _startRecording),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: _isLoading
                    ? Colors.grey
                    : _isRecording
                    ? Colors.red
                    : Colors.deepPurple,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_isRecording ? Colors.red : Colors.deepPurple)
                        .withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _isLoading
                  ? const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
                  : Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),

          if (_isRecording) ...[
            const SizedBox(width: 20),
            const Text(
              'Tap to stop',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ] else if (!_isLoading) ...[
            const SizedBox(width: 16),
            const Text(
              'Tap to speak',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}