import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health_app/models/mood.dart';

class FakeDocumentSnapshot extends Fake implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  final String id;

  final Map<String, dynamic>? _data;

  FakeDocumentSnapshot(this.id, this._data);

  @override
  Map<String, dynamic>? data() => _data;
}

void main() {
  group('Mood', () {
    final moodData = {
      'uid': 'test_uid',
      'name': 'Happy',
      'date': Timestamp.fromDate(DateTime(2023, 7, 20)),
      'description': 'Feeling great',
    };

    final moodDocument = FakeDocumentSnapshot('test_id', moodData);

    test('fromFirestore creates a Mood from Firestore document', () {
      final mood = Mood.fromFirestore(moodDocument);
      expect(mood.id, 'test_id');
      expect(mood.uid, 'test_uid');
      expect(mood.name, 'Happy');
      expect(mood.date, DateTime(2023, 7, 20));
      expect(mood.description, 'Feeling great');
    });

    test('toFirestore creates a map from a Mood', () {
      final mood = Mood(
        id: 'test_id',
        uid: 'test_uid',
        name: 'Happy',
        date: DateTime(2023, 7, 20),
        description: 'Feeling great',
      );
      final data = mood.toFirestore();
      expect(data['uid'], 'test_uid');
      expect(data['name'], 'Happy');
      expect(data['date'], Timestamp.fromDate(DateTime(2023, 7, 20)));
      expect(data['description'], 'Feeling great');
    });
  });
}
