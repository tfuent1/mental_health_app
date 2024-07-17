import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_health_app/models/duty.dart';

class DutyProvider with ChangeNotifier {
  List<Duty> _duties = [];
  final CollectionReference dutiesCollection = FirebaseFirestore.instance.collection('duties');

  List<Duty> get duties => _duties;

  DutyProvider() {
    _fetchDuties();
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
      final snapshot = await dutiesCollection.where('uid', isEqualTo: user.uid).get();
      _duties = snapshot.docs.map((doc) => Duty.fromFirestore(doc)).toList();
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
