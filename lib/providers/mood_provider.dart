import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/mood.dart';

class MoodProvider with ChangeNotifier {
  List<Mood> _moods = [];
  final CollectionReference moodsCollection =
      FirebaseFirestore.instance.collection('moods');

  MoodProvider() {
    _fetchMoods();
  }

  List<Mood> get moods => _moods;

  Future<void> _fetchMoods() async {
    final snapshot = await moodsCollection.get();
    _moods.clear();
    snapshot.docs.forEach((doc) {
      _moods.add(Mood.fromFirestore(doc));
    });
    notifyListeners();
  }

  Future<void> addMood(Mood mood) async {
    final docRef = await moodsCollection.add(mood.toFirestore());
    mood.id = docRef.id;
    _moods.add(mood);
    notifyListeners();
  }

  Future<void> removeMood(String id) async {
    await moodsCollection.doc(id).delete();
    _moods.removeWhere((mood) => mood.id == id);
    notifyListeners();
  }
}
