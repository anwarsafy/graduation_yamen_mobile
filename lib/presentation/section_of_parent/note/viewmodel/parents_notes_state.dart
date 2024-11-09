
import '../model/parents_notes_model.dart';

enum ParentNoteStateStatusUS { initial, loading, success, error }

class ParentNoteStateUS {
  final ParentNoteStateStatusUS status;
  final List<ParentNoteUS>? notes;
  final String? errorMessage;

  ParentNoteStateUS({required this.status, this.notes, this.errorMessage});

  factory ParentNoteStateUS.initial() {
    return ParentNoteStateUS(status: ParentNoteStateStatusUS.initial);
  }

  ParentNoteStateUS copyWith({
    ParentNoteStateStatusUS? status,
    List<ParentNoteUS>? notes,
    String? errorMessage,
  }) {
    return ParentNoteStateUS(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
