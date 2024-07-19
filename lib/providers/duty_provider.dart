import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/duty.dart';

class DutyProvider with ChangeNotifier {
  List<Duty> _duties = [];
  final CollectionReference dutiesCollection = FirebaseFirestore.instance.collection('duties');

  List<Duty> get duties => _duties;

  DutyProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchDuties();
      } else {
        clearDuties();
      }
    });
  }

  Future<void> _fetchDuties() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Fetching duties for user: ${user.uid}");
      try {
        final snapshot = await dutiesCollection.where('uid', isEqualTo: user.uid).get();
        if (snapshot.docs.isEmpty) {
          print("No duties found for user: ${user.uid}");
        } else {
          print("Duties found: ${snapshot.docs.length}");
          _duties = snapshot.docs.map((doc) => Duty.fromFirestore(doc)).toList();
          print("Fetched duties: ${_duties.length}");
        }
      } catch (error) {
        print("Error fetching duties: $error");
      }
      notifyListeners();
    }
  }

  Future<void> addDuty(Duty duty) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = await dutiesCollection.add({
        'uid': user.uid,
        'title': duty.title,
        'isCompleted': duty.isCompleted,
      });
      duty.id = docRef.id;
      duty.uid = user.uid;
      _duties.add(duty);
      notifyListeners();
    }
  }

  Future<void> updateDuty(String id, String title) async {
    final index = _duties.indexWhere((duty) => duty.id == id);
    if (index != -1) {
      _duties[index].title = title;
      await dutiesCollection.doc(id).update({
        'title': title,
      });
      notifyListeners();
    }
  }

  Future<void> toggleDutyCompletion(String id) async {
    final index = _duties.indexWhere((duty) => duty.id == id);
    if (index != -1) {
      _duties[index].isCompleted = !_duties[index].isCompleted;
      await dutiesCollection.doc(id).update({
        'isCompleted': _duties[index].isCompleted,
      });
      notifyListeners();
    }
  }

  Future<void> removeDuty(String id) async {
    await dutiesCollection.doc(id).delete();
    _duties.removeWhere((duty) => duty.id == id);
    notifyListeners();
  }

  void clearDuties() {
    _duties = [];
    notifyListeners();
  }
}
