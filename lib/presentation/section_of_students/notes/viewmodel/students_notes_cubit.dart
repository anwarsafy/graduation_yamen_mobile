
// 4. Define the Note Cubit
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_students/notes/viewmodel/students_notes_state.dart';

// ignore: unused_import
import '../../../section_of_teacher/notes/viewmodel/notes_state.dart';
import '../model/students_note_model.dart';

class NoteCubit extends Cubit<NoteStateUS> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NoteCubit() : super(NoteStateUS.initial());

  Future<void> fetchNotes() async {
    try {
      emit(state.copyWith(status: NoteStateStatusUS.loading));

      // Get current user's userId
      String currentUserId = _auth.currentUser!.uid;

      // Fetch notes where author is the current user
      QuerySnapshot<Map<String, dynamic>> notesSnapshot = await _firestore
          .collection('notes')
          .where('authorId', isEqualTo: currentUserId)
          .get();

      // Fetch notes assigned to the current user
      QuerySnapshot<Map<String, dynamic>> assignedNotesSnapshot =
      await _firestore
          .collection('notes')
          .where('assignedTo', isEqualTo: 'All Students')
          .get();
      // Fetch notes assigned to the all students
      QuerySnapshot<Map<String, dynamic>> assignedNotesSnapshot2 =
      await _firestore
          .collection('notes')
          .where('assignedTo', isEqualTo: 'All')
          .get();

      List<NoteUS> notes = [];

      // Add notes from both queries
      notes.addAll(notesSnapshot.docs.map((doc) => NoteUS.fromSnapshot(doc)).toList());
      notes.addAll(assignedNotesSnapshot.docs.map((doc) => NoteUS.fromSnapshot(doc)).toList());
      notes.addAll(assignedNotesSnapshot2.docs.map((doc) => NoteUS.fromSnapshot(doc)).toList());

      // Fetch all users
      QuerySnapshot<Map<String, dynamic>> usersSnapshot = await _firestore
          .collection('users')
          .get();
      List<UserUS> users = usersSnapshot.docs.map((doc) => UserUS.fromSnapshot(doc)).toList();

      emit(state.copyWith(status: NoteStateStatusUS.success, notes: notes, users: users));
    } catch (error) {
      emit(state.copyWith(status: NoteStateStatusUS.error, errorMessage: error.toString()));
    }
  }

  Future<void> addNote({
    required String content,
    required String assignedTo,
  }) async {
    try {
      // Get current user's userId
      String currentUserId = _auth.currentUser!.uid;

      // Get user's name
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore.collection('users').doc(currentUserId).get();
      String userName = userDoc.data()!['name'];

      // Add note to Firestore
      await _firestore.collection('notes').add({
        'content': content,
        'authorId': currentUserId,
        'authorName': userName,
        'assignedTo': assignedTo,
      });

      // Fetch notes again after adding
      fetchNotes();
    } catch (error) {
      emit(state.copyWith(status: NoteStateStatusUS.error, errorMessage: error.toString()));
    }
  }

  /// fetch users
  Future<void> fetchUsers() async {
    try {
      emit(state.copyWith(status: NoteStateStatusUS.loading));

      // Fetch all users
      QuerySnapshot<Map<String, dynamic>> usersSnapshot = await _firestore
          .collection('users')
          .get();
      List<UserUS> users = usersSnapshot.docs.map((doc) => UserUS.fromSnapshot(doc)).toList();

      emit(state.copyWith(status: NoteStateStatusUS.success, users: users));
    } catch (error) {
      emit(state.copyWith(status: NoteStateStatusUS.error, errorMessage: error.toString()));
    }
  }

  Future<void> addReply({
    required String noteId,
    required String replyContent,
  }) async {
    try {
      // Get current user's userId
      String currentUserId = _auth.currentUser!.uid;

      // Get user's name
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore.collection('users').doc(currentUserId).get();
      String userName = userDoc.data()!['name'];

      // Add reply to Firestore
      await _firestore.collection('notes').doc(noteId).collection('replies').add({
        'content': replyContent,
        'authorId': currentUserId,
        'authorName': userName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Fetch notes again after adding reply
      fetchNotes();
    } catch (error) {
      emit(state.copyWith(status: NoteStateStatusUS.error, errorMessage: error.toString()));
    }
  }
}