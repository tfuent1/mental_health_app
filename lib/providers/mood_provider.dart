import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/mood.dart';

class MoodProvider with ChangeNotifier {
  List<Mood> _moods = [];
  final CollectionReference moodsCollection;

  MoodProvider({CollectionReference? collection})
      : moodsCollection = collection ?? FirebaseFirestore.instance.collection('moods') {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _listenToMoods();
      } else {
        clearMoods();
      }
    });
  }

  List<Mood> get moods => _moods;

  void _listenToMoods() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      moodsCollection.where('uid', isEqualTo: user.uid).snapshots().listen((snapshot) {
        _moods = snapshot.docs.map((doc) => Mood.fromFirestore(doc)).toList();
        notifyListeners();
      });
    }
  }

  Future<void> addMood(Mood mood) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Adding mood with uid: ${user.uid}");
      try {
        final docRef = await moodsCollection.add({
          'uid': user.uid,
          'name': mood.name,
          'date': Timestamp.fromDate(mood.date),
          'description': mood.description,
        });
        mood.id = docRef.id;
        mood.uid = user.uid;
        notifyListeners();
      } catch (error) {
        print("Error adding mood: $error");
      }
    } else {
      print("User is not authenticated");
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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Deleting mood with id: $id and uid: ${user.uid}");
      try {
        await moodsCollection.doc(id).delete();
        _moods.removeWhere((mood) => mood.id == id);
        notifyListeners();
      } catch (error) {
        print("Error deleting mood: $error");
      }
    } else {
      print("User is not authenticated");
    }
  }

  void clearMoods() {
    _moods = [];
    notifyListeners();
  }
}
