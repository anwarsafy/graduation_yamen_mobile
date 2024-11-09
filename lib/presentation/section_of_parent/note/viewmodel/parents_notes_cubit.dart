import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_parent/note/viewmodel/parents_notes_state.dart';

import '../model/parents_notes_model.dart';


class ParentNoteCubit extends Cubit<ParentNoteStateUS> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ParentNoteCubit() : super(ParentNoteStateUS.initial());

  Future<void> fetchParentNotes() async {
    try {
      emit(state.copyWith(status: ParentNoteStateStatusUS.loading));
      String currentUserId = _auth.currentUser!.uid;

      // Fetch notes where author is the current parent
      QuerySnapshot<Map<String, dynamic>> notesSnapshot = await _firestore
          .collection('notes')
          .where('authorId', isEqualTo: currentUserId)
          .get();

      // Fetch notes assigned to "All Parents"
      QuerySnapshot<Map<String, dynamic>> assignedNotesSnapshot = await _firestore
          .collection('notes')
          .where('assignedTo', isEqualTo: 'All Parents')
          .get();

      // Fetch notes assigned to All
      QuerySnapshot<Map<String, dynamic>> assignedNotesSnapshot2 = await _firestore
          .collection('notes')
          .where('assignedTo', isEqualTo: 'All')
          .get();

      List<ParentNoteUS> notes = [];
      notes.addAll(notesSnapshot.docs.map((doc) => ParentNoteUS.fromSnapshot(doc)).toList());
      notes.addAll(assignedNotesSnapshot.docs.map((doc) => ParentNoteUS.fromSnapshot(doc)).toList());
      notes.addAll(assignedNotesSnapshot2.docs.map((doc) => ParentNoteUS.fromSnapshot(doc)).toList());

      emit(state.copyWith(status: ParentNoteStateStatusUS.success, notes: notes));
    } catch (error) {
      emit(state.copyWith(status: ParentNoteStateStatusUS.error, errorMessage: error.toString()));
    }
  }

  Future<void> addParentNote({
    required String content,
    required String assignedTo,
  }) async {
    try {
      String currentUserId = _auth.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore.collection('users').doc(currentUserId).get();
      String userName = userDoc.data()!['name'];

      await _firestore.collection('notes').add({
        'content': content,
        'authorId': currentUserId,
        'authorName': userName,
        'assignedTo': assignedTo,
      });

      fetchParentNotes();
    } catch (error) {
      emit(state.copyWith(status: ParentNoteStateStatusUS.error, errorMessage: error.toString()));
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

      fetchParentNotes();
    } catch (error) {
      emit(state.copyWith(status: ParentNoteStateStatusUS.error, errorMessage: error.toString()));
    }
  }
}
