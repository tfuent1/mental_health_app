import 'package:flutter/material.dart';
import '../models/emotion.dart';

class EmotionProvider with ChangeNotifier {
  List<Emotion> _emotions = [];

  List<Emotion> get emotions => _emotions;

  void addEmotion(Emotion emotion) {
    _emotions.add(emotion);
    notifyListeners();
  }

  void removeEmotion(String id) {
    _emotions.removeWhere((emotion) => emotion.id == id);
    notifyListeners();
  }
}
