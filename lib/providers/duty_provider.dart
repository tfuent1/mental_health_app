import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/duty.dart';

class DutyProvider with ChangeNotifier {
  final List<Duty> _duties = [];
  final CollectionReference dutiesCollection =
      FirebaseFirestore.instance.collection('duties');

  DutyProvider() {
    _fetchDuties();
  }

  List<Duty> get duties => _duties;

  Future<void> _fetchDuties() async {
    final snapshot = await dutiesCollection.get();
    _duties.clear();
    snapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>;
      _duties.add(Duty(
        id: doc.id,
        title: data['title'],
        isCompleted: data['isCompleted'],
      ));
    });
    notifyListeners();
  }

  Future<void> addDuty(Duty duty) async {
    final docRef = await dutiesCollection.add({
      'title': duty.title,
      'isCompleted': duty.isCompleted,
    });
    duty.id = docRef.id;
    _duties.add(duty);
    notifyListeners();
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
}
