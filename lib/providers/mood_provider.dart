import 'package:flutter/material.dart';
import '../models/mood.dart';

class MoodProvider with ChangeNotifier {
  List<Mood> _moods = [];

  List<Mood> get moods => _moods;

  void addMood(Mood mood) {
    _moods.add(mood);
    notifyListeners();
  }

  void removeEmotion(String id) {
    _moods.removeWhere((mood) => mood.id == id);
    notifyListeners();
  }
}
