import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/journal_entry.dart';

class JournalProvider with ChangeNotifier {
  List<JournalEntry> _entries = [];
  final CollectionReference journalCollection;

  JournalProvider({CollectionReference? collection})
      : journalCollection = collection ?? FirebaseFirestore.instance.collection('journal_entries') {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _listenToEntries();
      } else {
        clearEntries();
      }
    });
  }

  List<JournalEntry> get entries => _entries;

  void _listenToEntries() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      journalCollection.where('uid', isEqualTo: user.uid).snapshots().listen((snapshot) {
        _entries = snapshot.docs.map((doc) => JournalEntry.fromFirestore(doc)).toList();
        notifyListeners();
      });
    }
  }

  Future<void> addEntry(JournalEntry entry) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Adding journal entry with uid: ${user.uid}");
      try {
        final docRef = await journalCollection.add({
          'uid': user.uid,
          'title': entry.title,
          'content': entry.content,
          'date': Timestamp.fromDate(entry.date),
        });
        entry.id = docRef.id;
        entry.uid = user.uid;
        notifyListeners();
      } catch (error) {
        print("Error adding journal entry: $error");
      }
    } else {
      print("User is not authenticated");
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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Deleting journal entry with id: $id and uid: ${user.uid}");
      try {
        await journalCollection.doc(id).delete();
        _entries.removeWhere((entry) => entry.id == id);
        notifyListeners();
      } catch (error) {
        print("Error deleting journal entry: $error");
      }
    } else {
      print("User is not authenticated");
    }
  }

  void clearEntries() {
    _entries = [];
    notifyListeners();
  }
}
