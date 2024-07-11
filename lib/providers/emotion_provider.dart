import 'package:flutter/material.dart';
import '../models/emotion.dart';

class EmotionProvider with ChangeNotifier {
  final List<Emotion> _emotions = [];

  List<Emotion> get emotions => _emotions;

  void addEmotion(Emotion emotion) {
    _emotions.add(emotion);
    notifyListeners();
  }

  // Additional methods for managing emotions if needed
}
