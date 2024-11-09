import 'package:cloud_firestore/cloud_firestore.dart';

class ParentNoteUS {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final String? assignedTo;

  ParentNoteUS({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.assignedTo,
  });

  factory ParentNoteUS.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return ParentNoteUS(
      id: snapshot.id,
      content: data?['content'] ?? '',
      authorId: data?['authorId'] ?? '',
      authorName: data?['authorName'] ?? '',
      assignedTo: data?['assignedTo'],
    );
  }
}

class ParentUserUS {
  final String id;
  final String name;
  final String email;
  final String userType;

  ParentUserUS({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
  });

  factory ParentUserUS.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return ParentUserUS(
      id: snapshot.id,
      name: data?['name'] ?? '',
      email: data?['email'] ?? '',
      userType: data?['userType'] ?? '',
    );
  }
}
