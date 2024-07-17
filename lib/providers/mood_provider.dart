import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    _moods = snapshot.docs.map((doc) => Mood.fromFirestore(doc)).toList();
    notifyListeners();  // Notify listeners after fetching data
  }

  Future<void> addMood(Mood mood) async {
    final docRef = await moodsCollection.add(mood.toFirestore());
    mood.id = docRef.id;
    _moods.add(mood);
    notifyListeners();  // Notify listeners after adding a mood
  }

  Future<void> removeMood(String id) async {
    await moodsCollection.doc(id).delete();
    _moods.removeWhere((mood) => mood.id == id);
    notifyListeners();  // Notify listeners after removing a mood
  }
}
