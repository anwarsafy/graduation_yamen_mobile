import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_manger_state.dart';
enum TaskType { project, assignment, exam, quiz }

class AssignmentCubit extends Cubit<AssignmentState> {
  AssignmentCubit() : super( const AssignmentState());

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Setters to update assignment details in the state
  void setLevel(String level) {
    emit(state.copyWith(level: level));
  }

  void setDepartment(String department) {
    emit(state.copyWith(department: department));
  }

  void setCourseName(String courseName) {
    emit(state.copyWith(courseName: courseName));
  }

  void setTaskDate(DateTime date) {
    emit(state.copyWith(taskDate: date));
  }

  void setTaskType(TaskType type) {
    emit(state.copyWith(taskType: type));
  }

  void setSelectedStudents(List<String> students) {
    emit(state.copyWith(selectedStudents: students));
  }

  void setSelectedAssignmentId(String assignmentId) {
    emit(state.copyWith(selectedAssignmentId: assignmentId));
  }

  /// Add a new assignment to Firestore
  Future<void> addAssignment() async {
    final assignmentData = {
      'level': state.level,
      'department': state.department,
      'courseName': state.courseName,
      'taskDate': state.taskDate?.toIso8601String(),
      'taskType': state.taskType.toString().split('.').last,
      'students': state.selectedStudents,
    };

    await firestore.collection('assignments').add(assignmentData);
  }
  /// Fetch all submissions
  /// Fetch all submissions from all assignments
  Future<void> fetchAllSubmissions() async {
    emit(state.copyWith(isLoading: true));
    try {
      List<Map<String, dynamic>> allSubmissions = [];

      // Fetch all assignments
      QuerySnapshot assignmentsSnapshot = await firestore.collection('assignments').get();

      for (var assignmentDoc in assignmentsSnapshot.docs) {
        String assignmentId = assignmentDoc.id;

        // Fetch submissions for each assignment
        QuerySnapshot submissionsSnapshot = await firestore
            .collection('assignments')
            .doc(assignmentId)
            .collection('submitted')
            .get();

        for (var submissionDoc in submissionsSnapshot.docs) {
          // Add both assignmentId and submissionId to the data map
          allSubmissions.add({
            'assignmentId': assignmentId,
            'submissionId': submissionDoc.id,
            'email': submissionDoc['email'],
            'fileUrl': submissionDoc['fileUrl'],
            'submissionDate': submissionDoc['submissionDate'],
            'rating': submissionDoc['rating'] ?? '',
          });
        }
      }

      emit(state.copyWith(submissions: allSubmissions, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Update the rating for a student's submission
  Future<void> updateRating(String assignmentId, String submissionId, String rating) async {
    try {
      await firestore
          .collection('assignments')
          .doc(assignmentId)
          .collection('submitted')
          .doc(submissionId)
          .update({'rating': rating});
    // ignore: empty_catches
    } catch (e) {
    }
  }

}
