
// 1. Define the Note State
// ignore: unused_import
import '../../../section_of_students/notes/model/students_note_model.dart';
import '../model/teacher_notes_model.dart';

enum NoteStateStatus { initial, loading, success, error }

class NoteState {
  final NoteStateStatus status;
  final List<Note>? notes;
  final String? errorMessage;

  NoteState({required this.status, this.notes, this.errorMessage});

  factory NoteState.initial() {
    return NoteState(status: NoteStateStatus.initial);
  }

  NoteState copyWith({
    NoteStateStatus? status,
    List<Note>? notes,
    String? errorMessage,
  }) {
    return NoteState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
