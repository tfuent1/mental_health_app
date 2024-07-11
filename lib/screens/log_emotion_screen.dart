import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emotion_provider.dart';
import '../models/emotion.dart';

class LogEmotionScreen extends StatefulWidget {
  const LogEmotionScreen({super.key});

  @override
  _LogEmotionScreenState createState() => _LogEmotionScreenState();
}

class _LogEmotionScreenState extends State<LogEmotionScreen> {
  final TextEditingController _intensityController = TextEditingController();
  String? _selectedEmotion;

  @override
  Widget build(BuildContext context) {
    final emotions = [
      {'emoji': '😊', 'name': 'Happy'},
      {'emoji': '😢', 'name': 'Sad'},
      {'emoji': '😠', 'name': 'Angry'},
      {'emoji': '😨', 'name': 'Fearful'},
      {'emoji': '😒', 'name': 'Disgusted'},
      {'emoji': '😔', 'name': 'Bad'},
      {'emoji': '😲', 'name': 'Surprised'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Emotion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Wrap(
              spacing: 10.0,
              children: emotions.map((emotion) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedEmotion = emotion['name'];
                    });
                  },
                  child: Text(emotion['emoji']!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedEmotion == emotion['name']
                        ? Colors.blue
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),
            TextField(
              controller: _intensityController,
              decoration: const InputDecoration(labelText: 'Intensity (1-10)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_intensityController.text.isNotEmpty && _selectedEmotion != null) {
                  final emotion = Emotion(
                    id: DateTime.now().toString(),
                    name: _selectedEmotion!,
                    intensity: int.parse(_intensityController.text),
                    date: DateTime.now(),
                  );
                  Provider.of<EmotionProvider>(context, listen: false).addEmotion(emotion);
                  Navigator.pop(context);
                }
              },
              child: const Text('Log Emotion'),
            ),
          ],
        ),
      ),
    );
  }
}
