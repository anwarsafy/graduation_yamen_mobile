// 2. Define the Note Model
import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final String? assignedTo; // Email of the assigned user (student, parent, teacher)

  Note({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.assignedTo,
  });

  // Use this to create Note object from Firestore snapshot
  factory Note.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Note(
      id: snapshot.id,
      content: snapshot.data()!['content'],
      authorId: snapshot.data()!['authorId'],
      authorName: snapshot.data()!['authorName'],
      assignedTo: snapshot.data()!['assignedTo'],
    );
  }
}
