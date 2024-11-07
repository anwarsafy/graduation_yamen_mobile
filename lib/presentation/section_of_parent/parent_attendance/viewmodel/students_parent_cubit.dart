import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_parent/parent_attendance/viewmodel/students_parent_state.dart';

class AttendanceCubitParent extends Cubit<AttendanceStateParent> {
  AttendanceCubitParent() : super(AttendanceStateParent.initial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchAttendanceData() async {
    try {
      // Get the current user's ID
      String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        emit(state.copyWith(error: "User not logged in"));
        return;
      }

      // Get the user's data from Firestore
      DocumentSnapshot userSnapshot =
      await _firestore.collection('users').doc(userId).get();

      // Check if the user is a parent
      if (userSnapshot.get('userType') != 'parent') {
        emit(state.copyWith(error: "User is not a parent"));
        return;
      }

      // Get the selected student IDs from the user's document
      Map<String, dynamic> selectedStudent = userSnapshot.get('selectedStudent');
      List<String> studentIds = List<String>.from(selectedStudent['studentIds']);

      // Fetch attendance data for each student
      List<Map<String, dynamic>> attendanceData = [];
      for (String studentId in studentIds) {
        QuerySnapshot attendanceSnapshot = await _firestore
            .collection('attendance')
            .where('email', isEqualTo: studentId) // Use 'email' for filtering
            .get();

        for (var doc in attendanceSnapshot.docs) {
          attendanceData.add(doc.data() as Map<String, dynamic>);
        }
      }

      // Emit the attendance data
      emit(state.copyWith(
        attendanceData: attendanceData,
        error: null,
      ));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }
}
