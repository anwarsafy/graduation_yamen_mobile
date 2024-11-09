// 1. Define the Note Model
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteUS {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final String? assignedTo;

  NoteUS({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.assignedTo,
  });

  // Use this to create Note object from Firestore snapshot
  factory NoteUS.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return NoteUS(
      id: snapshot.id,
      content: data?['content'] ?? '', // Default to empty string if null
      authorId: data?['authorId'] ?? '',
      authorName: data?['authorName'] ?? '',
      assignedTo: data?['assignedTo'],
    );
  }
}

// 2. Define the User Model
class UserUS {
  final String id;
  final String name;
  final String email;
  final String userType;

  UserUS({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
  });

  // Use this to create User object from Firestore snapshot
  factory UserUS.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return UserUS(
      id: snapshot.id,
      name: data?['name'] ?? '', // Default to empty string if null
      email: data?['email'] ?? '',
      userType: data?['userType'] ?? '',
    );
  }
}
