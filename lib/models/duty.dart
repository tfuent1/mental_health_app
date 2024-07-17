import 'package:cloud_firestore/cloud_firestore.dart';

class Duty {
  String id;
  String title;
  bool isCompleted;

  Duty({required this.id, required this.title, this.isCompleted = false});

  factory Duty.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Duty(
      id: doc.id,
      title: data['title'],
      isCompleted: data['isCompleted'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
