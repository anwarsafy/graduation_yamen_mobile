// 3. Define the Note Cubit
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/teacher_notes_model.dart';
import 'notes_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NoteCubit() : super(NoteState.initial());

  Future<void> fetchNotes() async {
    try {
      emit(state.copyWith(status: NoteStateStatus.loading));

      // Get current teacher's userId
      String currentTeacherId = _auth.currentUser!.uid;

      // Fetch notes where author is the current teacher
      QuerySnapshot<Map<String, dynamic>> notesSnapshot = await _firestore
          .collection('notes')
          .where('authorId', isEqualTo: currentTeacherId)
          .get();

      // Fetch notes assigned to the current teacher
      QuerySnapshot<Map<String, dynamic>> assignedNotesSnapshot =
      await _firestore
          .collection('notes')
          .where('assignedTo', isEqualTo: _auth.currentUser!.email)
          .get();

      List<Note> notes = [];

      // Add notes from both queries
      notes.addAll(notesSnapshot.docs.map((doc) => Note.fromSnapshot(doc)).toList());
      notes.addAll(assignedNotesSnapshot.docs.map((doc) => Note.fromSnapshot(doc)).toList());

      emit(state.copyWith(status: NoteStateStatus.success, notes: notes));
    } catch (error) {
      emit(state.copyWith(status: NoteStateStatus.error, errorMessage: error.toString()));
    }
  }

  Future<void> addNote({
    required String content,
    required String assignedTo,
  }) async {
    try {
      // Get current teacher's userId
      String currentTeacherId = _auth.currentUser!.uid;

      // Get teacher's name
      DocumentSnapshot<Map<String, dynamic>> teacherDoc = await _firestore.collection('users').doc(currentTeacherId).get();
      String teacherName = teacherDoc.data()!['name'];

      // Add note to Firestore
      await _firestore.collection('notes').add({
        'content': content,
        'authorId': currentTeacherId,
        'authorName': teacherName,
        'assignedTo': assignedTo,
      });

      // Fetch notes again after adding
      fetchNotes();
    } catch (error) {
      emit(state.copyWith(status: NoteStateStatus.error, errorMessage: error.toString()));
    }
  }

  Future<void> addReply({
    required String noteId,
    required String replyContent,
  }) async {
    try {
      // Get current teacher's userId
      String currentTeacherId = _auth.currentUser!.uid;

      // Get teacher's name
      DocumentSnapshot<Map<String, dynamic>> teacherDoc = await _firestore.collection('users').doc(currentTeacherId).get();
      String teacherName = teacherDoc.data()!['name'];

      // Add reply to Firestore
      await _firestore.collection('notes').doc(noteId).collection('replies').add({
        'content': replyContent,
        'authorId': currentTeacherId,
        'authorName': teacherName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Fetch notes again after adding reply
      fetchNotes();
    } catch (error) {
      emit(state.copyWith(status: NoteStateStatus.error, errorMessage: error.toString()));
    }
  }
}
