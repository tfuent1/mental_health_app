import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emotion_provider.dart';

class ViewEmotionsScreen extends StatelessWidget {
  const ViewEmotionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Emotions'),
      ),
      body: Consumer<EmotionProvider>(
        builder: (context, emotionProvider, child) {
          return ListView.builder(
            itemCount: emotionProvider.emotions.length,
            itemBuilder: (context, index) {
              final emotion = emotionProvider.emotions[index];
              return ListTile(
                title: Text(emotion.name),
                subtitle: Text('Intensity: ${emotion.intensity} | Date: ${emotion.date}'),
              );
            },
          );
        },
      ),
    );
  }
}
