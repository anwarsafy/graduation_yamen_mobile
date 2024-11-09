// 3. Define the Note State
import '../model/students_note_model.dart';

enum NoteStateStatusUS { initial, loading, success, error }

class NoteStateUS {
  final NoteStateStatusUS status;
  final List<NoteUS>? notes;
  final String? errorMessage;
  final List<UserUS>? users;

  NoteStateUS({required this.status, this.notes, this.errorMessage, this.users});

  factory NoteStateUS.initial() {
    return NoteStateUS(status: NoteStateStatusUS.initial);
  }

  NoteStateUS copyWith({
    NoteStateStatusUS? status,
    List<NoteUS>? notes,
    String? errorMessage,
    List<UserUS>? users,
  }) {
    return NoteStateUS(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      errorMessage: errorMessage ?? this.errorMessage,
      users: users ?? this.users,
    );
  }
}