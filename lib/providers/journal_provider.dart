import 'package:flutter/material.dart';
import '../models/journal_entry.dart';

class JournalProvider with ChangeNotifier {
  final List<JournalEntry> _entries = [];

  List<JournalEntry> get entries => _entries;

  void addEntry(JournalEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void removeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}
