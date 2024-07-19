import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/journal_entry.dart';

class JournalProvider with ChangeNotifier {
  List<JournalEntry> _entries = [];
  final CollectionReference journalCollection = FirebaseFirestore.instance.collection('journal_entries');

  List<JournalEntry> get entries => _entries;

  JournalProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _fetchEntries();
      } else {
        clearEntries();
      }
    });
  }

  Future<void> _fetchEntries() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await journalCollection.where('uid', isEqualTo: user.uid).get();
      _entries = snapshot.docs.map((doc) => JournalEntry.fromFirestore(doc)).toList();
      notifyListeners();
    }
  }

  Future<void> addEntry(JournalEntry entry) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = await journalCollection.add({
        'uid': user.uid,
        'title': entry.title,
        'content': entry.content,
        'date': Timestamp.fromDate(entry.date),
      });
      entry.id = docRef.id;
      entry.uid = user.uid;
      _entries.add(entry);
      notifyListeners();
    }
  }

  Future<void> updateEntry(String id, String title, String content) async {
    final index = _entries.indexWhere((entry) => entry.id == id);
    if (index != -1) {
      _entries[index].title = title;
      _entries[index].content = content;
      await journalCollection.doc(id).update({
        'title': title,
        'content': content,
      });
      notifyListeners();
    }
  }

  Future<void> removeEntry(String id) async {
    await journalCollection.doc(id).delete();
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }

  void clearEntries() {
    _entries = [];
    notifyListeners();
  }
}
