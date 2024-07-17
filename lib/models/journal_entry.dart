import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  String id;
  String title;
  String content;
  DateTime date;

  JournalEntry({required this.id, required this.title, required this.content, required this.date});

  factory JournalEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JournalEntry(
      id: doc.id,
      title: data['title'],
      content: data['content'],
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'date': Timestamp.fromDate(date),
    };
  }
}
