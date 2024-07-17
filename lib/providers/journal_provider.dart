import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/models/journal_entry.dart';

class JournalProvider with ChangeNotifier {
  final List<JournalEntry> _entries = [];
  final CollectionReference journalCollection =
      FirebaseFirestore.instance.collection('journal_entries');

  JournalProvider() {
    _fetchEntries();
  }

  List<JournalEntry> get entries => _entries;

  Future<void> _fetchEntries() async {
    final snapshot = await journalCollection.get();
    _entries.clear();
    snapshot.docs.forEach((doc) {
      _entries.add(JournalEntry.fromFirestore(doc));
    });
    notifyListeners();
  }

  Future<void> addEntry(JournalEntry entry) async {
    final docRef = await journalCollection.add(entry.toFirestore());
    entry.id = docRef.id;
    _entries.add(entry);
    notifyListeners();
  }

  Future<void> removeEntry(String id) async {
    await journalCollection.doc(id).delete();
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}
