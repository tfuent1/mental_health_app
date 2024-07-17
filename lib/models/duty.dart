import 'package:cloud_firestore/cloud_firestore.dart';

class Duty {
  String id;
  String uid;
  String title;
  bool isCompleted;

  Duty({required this.id, required this.uid, required this.title, this.isCompleted = false});

  factory Duty.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Duty(
      id: doc.id,
      uid: data['userId'],
      title: data['title'],
      isCompleted: data['isCompleted'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': uid,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
