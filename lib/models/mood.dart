import 'package:cloud_firestore/cloud_firestore.dart';

class Mood {
  String id;
  String uid;
  String name;
  DateTime date;
  String description;

  Mood({required this.id, required this.uid, required this.name, required this.date, required this.description});

  factory Mood.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Mood(
      id: doc.id,
      uid: data['uid'],
      name: data['name'],
      date: (data['date'] as Timestamp).toDate(),
      description: data['description'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'date': Timestamp.fromDate(date),
      'description': description,
    };
  }
}
