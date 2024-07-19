import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/mood.dart';

class MoodProvider with ChangeNotifier {
  List<Mood> _moods = [];
  final CollectionReference moodsCollection = FirebaseFirestore.instance.collection('moods');

  List<Mood> get moods => _moods;

  MoodProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchMoods();
      } else {
        clearMoods();
      }
    });
  }

  Future<void> _fetchMoods() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await moodsCollection.where('uid', isEqualTo: user.uid).get();
      _moods = snapshot.docs.map((doc) => Mood.fromFirestore(doc)).toList();
      notifyListeners();
    }
  }

  Future<void> addMood(Mood mood) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = await moodsCollection.add({
        'uid': user.uid,
        'name': mood.name,
        'date': Timestamp.fromDate(mood.date),
        'description': mood.description,
      });
      mood.id = docRef.id;
      mood.uid = user.uid;
      _moods.add(mood);
      notifyListeners();
    }
  }

  Future<void> updateMood(String id, String name, String description) async {
    final index = _moods.indexWhere((mood) => mood.id == id);
    if (index != -1) {
      _moods[index].name = name;
      _moods[index].description = description;
      await moodsCollection.doc(id).update({
        'name': name,
        'description': description,
      });
      notifyListeners();
    }
  }

  Future<void> removeMood(String id) async {
    await moodsCollection.doc(id).delete();
    _moods.removeWhere((mood) => mood.id == id);
    notifyListeners();
  }

  void clearMoods() {
    _moods = [];
    notifyListeners();
  }
}
