import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_parent/tasks/viewmodel/parent_tasks_state.dart';

class TasksCubitParent extends Cubit<TasksStateParent> {
  TasksCubitParent() : super(TasksStateParent.initial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchTasksData() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        emit(state.copyWith(error: "User not logged in"));
        return;
      }

      // Fetch the parent's selected students
      DocumentSnapshot userSnapshot =
      await _firestore.collection('users').doc(userId).get();
      if (userSnapshot.get('userType') != 'parent') {
        emit(state.copyWith(error: "User is not a parent"));
        return;
      }

      Map<String, dynamic> selectedStudent = userSnapshot.get('selectedStudent');
      List<String> studentIds = List<String>.from(selectedStudent['studentIds']);

      // Fetch tasks related to the selected students
      List<Map<String, dynamic>> tasksData = [];
      QuerySnapshot assignmentsSnapshot = await _firestore
          .collection('assignments')
          .where('students', arrayContainsAny: studentIds)
          .get();

      for (var doc in assignmentsSnapshot.docs) {
        Map<String, dynamic> taskData = doc.data() as Map<String, dynamic>;

        // Fetch submissions for each task
        QuerySnapshot submissionSnapshot = await _firestore
            .collection('assignments')
            .doc(doc.id)
            .collection('submitted')
            .where('email', whereIn: studentIds)
            .get();

        List<Map<String, dynamic>> submissions = [];
        for (var submissionDoc in submissionSnapshot.docs) {
          submissions.add(submissionDoc.data() as Map<String, dynamic>);
        }

        taskData['submissions'] = submissions;
        tasksData.add(taskData);
      }

      emit(state.copyWith(tasksData: tasksData, error: null));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }
}
