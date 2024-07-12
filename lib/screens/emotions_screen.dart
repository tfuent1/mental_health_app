import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emotion_provider.dart';
import '../models/emotion.dart';

class EmotionsScreen extends StatefulWidget {
  const EmotionsScreen({super.key});

  @override
  _EmotionsScreenState createState() => _EmotionsScreenState();
}

class _EmotionsScreenState extends State<EmotionsScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  double _intensity = 1;
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
        title: const Text('Emotions'),
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
            const SizedBox(height: 20),
            Text('Intensity: ${_intensity.round()}'),
            Slider(
              value: _intensity,
              min: 1,
              max: 10,
              divisions: 9,
              label: _intensity.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _intensity = value;
                });
              },
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_selectedEmotion != null) {
                  final emotion = Emotion(
                    id: DateTime.now().toString(),
                    name: _selectedEmotion!,
                    intensity: _intensity.round(),
                    date: DateTime.now(),
                    description: _descriptionController.text,
                  );
                  Provider.of<EmotionProvider>(context, listen: false).addEmotion(emotion);
                  setState(() {
                    _selectedEmotion = null;
                    _intensity = 1;
                    _descriptionController.clear();
                  });
                }
              },
              child: const Text('Log Emotion'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<EmotionProvider>(
                builder: (context, emotionProvider, child) {
                  return ListView.builder(
                    itemCount: emotionProvider.emotions.length,
                    itemBuilder: (context, index) {
                      final emotion = emotionProvider.emotions[index];
                      return ListTile(
                        title: Text(emotion.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Intensity: ${emotion.intensity}'),
                            Text('Description: ${emotion.description}'),
                            Text('Date: ${emotion.date}'),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
