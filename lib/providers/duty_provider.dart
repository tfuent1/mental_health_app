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
        _listenToDuties();
      } else {
        clearDuties();
      }
    });
  }

  void _listenToDuties() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      dutiesCollection.where('uid', isEqualTo: user.uid).snapshots().listen((snapshot) {
        _duties = snapshot.docs.map((doc) => Duty.fromFirestore(doc)).toList();
        notifyListeners();
      });
    }
  }

  Future<void> addDuty(Duty duty) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Adding duty with uid: ${user.uid}");
      try {
        final docRef = await dutiesCollection.add({
          'uid': user.uid,
          'title': duty.title,
          'isCompleted': duty.isCompleted,
        });
        duty.id = docRef.id;
        duty.uid = user.uid;
        notifyListeners();
      } catch (error) {
        print("Error adding duty: $error");
      }
    } else {
      print("User is not authenticated");
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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Deleting duty with id: $id and uid: ${user.uid}");
      try {
        await dutiesCollection.doc(id).delete();
        _duties.removeWhere((duty) => duty.id == id);
        notifyListeners();
      } catch (error) {
        print("Error deleting duty: $error");
      }
    } else {
      print("User is not authenticated");
    }
  }

  void clearDuties() {
    _duties = [];
    notifyListeners();
  }
}
