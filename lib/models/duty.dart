import 'package:cloud_firestore/cloud_firestore.dart';

class Duty {
  String id;
  String uid;
  String title;
  bool isCompleted;

  Duty({
    required this.id,
    required this.uid,
    required this.title,
    this.isCompleted = false,
  });

  factory Duty.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Duty(
      id: doc.id,
      uid: data['uid'] ?? '',  // Handle potential null values
      title: data['title'] ?? '',  // Handle potential null values
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
