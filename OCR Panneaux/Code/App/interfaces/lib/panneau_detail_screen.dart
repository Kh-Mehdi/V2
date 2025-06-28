import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../utils/tts_service.dart';

class PanneauDetailScreen extends StatefulWidget {
  final String panneauName;
  final String description;
  final double confidence;

  const PanneauDetailScreen({
    super.key,
    required this.panneauName,
    required this.description,
    required this.confidence,
  });

  @override
  _PanneauDetailScreenState createState() => _PanneauDetailScreenState();
}

class _PanneauDetailScreenState extends State<PanneauDetailScreen> {
  final TTSService ttsService = TTSService();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    ttsService.initTTS();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.panneauName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/sign_details.png', height: 200),
            ),
            const SizedBox(height: 20),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Center(
              child: IconButton(
                icon: Icon(_isSpeaking ? Icons.volume_off : Icons.volume_up),
                iconSize: 50,
                onPressed: () async {
                  if (_isSpeaking) {
                    await ttsService.stop();
                  } else {
                    await ttsService.speak(widget.description);
                  }
                  setState(() => _isSpeaking = !_isSpeaking);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    ttsService.dispose();
    super.dispose();
  }
}
