import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_health_app/models/duty.dart';

class FakeDocumentSnapshot extends Fake implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  final String id;

  final Map<String, dynamic>? _data;

  FakeDocumentSnapshot(this.id, this._data);

  @override
  Map<String, dynamic>? data() => _data;
}

void main() {
  group('Duty', () {
    final dutyData = {
      'uid': 'test_uid',
      'title': 'Test Duty',
      'isCompleted': true,
    };

    final dutyDocument = FakeDocumentSnapshot('test_id', dutyData);

    test('fromFirestore creates a Duty from Firestore document', () {
      final duty = Duty.fromFirestore(dutyDocument);
      expect(duty.id, 'test_id');
      expect(duty.uid, 'test_uid');
      expect(duty.title, 'Test Duty');
      expect(duty.isCompleted, true);
    });

    test('toFirestore creates a map from a Duty', () {
      final duty = Duty(
        id: 'test_id',
        uid: 'test_uid',
        title: 'Test Duty',
        isCompleted: true,
      );
      final data = duty.toFirestore();
      expect(data['uid'], 'test_uid');
      expect(data['title'], 'Test Duty');
      expect(data['isCompleted'], true);
    });
  });
}
