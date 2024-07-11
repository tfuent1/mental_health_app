import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emotion_provider.dart';
import '../models/emotion.dart';

class EmotionSelector extends StatelessWidget {
  final List<String> emotions = ['Happy', 'Sad', 'Angry', 'Anxious', 'Excited'];
  final TextEditingController _intensityController = TextEditingController();

  EmotionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DropdownButton<String>(
          hint: const Text('Select Emotion'),
          items: emotions.map((String emotion) {
            return DropdownMenuItem<String>(
              value: emotion,
              child: Text(emotion),
            );
          }).toList(),
          onChanged: (String? value) {
            if (value != null) {
              final emotion = Emotion(
                id: DateTime.now().toString(),
                name: value,
                intensity: int.parse(_intensityController.text),
                date: DateTime.now(),
              );
              Provider.of<EmotionProvider>(context, listen: false).addEmotion(emotion);
            }
          },
        ),
        TextField(
          controller: _intensityController,
          decoration: const InputDecoration(labelText: 'Intensity (1-10)'),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
