
import 'package:equatable/equatable.dart';

class StudentState extends Equatable {
  final DateTime selectedDate;
  final String email;
  final List<Map<String, dynamic>> assignments;

  StudentState({
    DateTime? selectedDate,
    this.email = '',
    List<Map<String, dynamic>>? assignments,
  })  : selectedDate = selectedDate ?? DateTime.now(),
        assignments = assignments ?? [];

  StudentState copyWith({
    DateTime? selectedDate,
    String? email,
    List<Map<String, dynamic>>? assignments,
  }) {
    return StudentState(
      selectedDate: selectedDate ?? this.selectedDate,
      email: email ?? this.email,
      assignments: assignments ?? this.assignments,
    );
  }

  @override
  List<Object?> get props => [selectedDate, email, assignments];
}
