import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health_app/models/journal_entry.dart';

// ignore: subtype_of_sealed_class
class FakeDocumentSnapshot extends Fake implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  final String id;

  final Map<String, dynamic>? _data;

  FakeDocumentSnapshot(this.id, this._data);

  @override
  Map<String, dynamic>? data() => _data;
}

void main() {
  group('JournalEntry', () {
    final journalData = {
      'uid': 'test_uid',
      'title': 'Test Entry',
      'content': 'This is a test entry',
      'date': Timestamp.fromDate(DateTime(2023, 7, 20)),
    };

    final journalDocument = FakeDocumentSnapshot('test_id', journalData);

    test('fromFirestore creates a JournalEntry from Firestore document', () {
      final journalEntry = JournalEntry.fromFirestore(journalDocument);
      expect(journalEntry.id, 'test_id');
      expect(journalEntry.uid, 'test_uid');
      expect(journalEntry.title, 'Test Entry');
      expect(journalEntry.content, 'This is a test entry');
      expect(journalEntry.date, DateTime(2023, 7, 20));
    });

    test('toFirestore creates a map from a JournalEntry', () {
      final journalEntry = JournalEntry(
        id: 'test_id',
        uid: 'test_uid',
        title: 'Test Entry',
        content: 'This is a test entry',
        date: DateTime(2023, 7, 20),
      );
      final data = journalEntry.toFirestore();
      expect(data['uid'], 'test_uid');
      expect(data['title'], 'Test Entry');
      expect(data['content'], 'This is a test entry');
      expect(data['date'], Timestamp.fromDate(DateTime(2023, 7, 20)));
    });
  });
}
