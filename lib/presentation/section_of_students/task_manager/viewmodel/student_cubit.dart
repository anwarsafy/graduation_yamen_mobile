import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_students/task_manager/viewmodel/student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  StudentCubit() : super(StudentState());

  void setSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
    fetchAssignmentsForStudent(state.email);
  }

  void setEmail(String email) {
    emit(state.copyWith(email: email));
    fetchAssignmentsForStudent(email);
  }

  Future<void> fetchAssignmentsForStudent(String email) async {
    try {
      // Fetch assignments where the student is included
      QuerySnapshot snapshot = await firestore
          .collection('assignments')
          .where('students', arrayContains: email)
          .get();

      List<Map<String, dynamic>> assignments = [];

      for (var doc in snapshot.docs) {
        String assignmentId = doc.id;

        // Fetch rating from the 'submitted' subcollection for this assignment
        QuerySnapshot submittedSnapshot = await firestore
            .collection('assignments')
            .doc(assignmentId)
            .collection('submitted')
            .where('email', isEqualTo: email)
            .get();

        String? rating;
        if (submittedSnapshot.docs.isNotEmpty) {
          // Extract rating if the submission exists
          rating = submittedSnapshot.docs.first['rating'];
        }

        // Add assignment data to the list
        assignments.add({
          'id': assignmentId,
          'level': doc['level'],
          'department': doc['department'],
          'courseName': doc['courseName'],
          'taskDate': DateTime.parse(doc['taskDate']),
          'taskType': doc['taskType'],
          'rating': rating ?? 'Not rated yet', // Use 'Not rated yet' if no rating found
        });
      }

      // Emit the updated state with fetched assignments
      emit(state.copyWith(assignments: assignments));
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching assignments: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  // Method to pick and upload a file
  Future<void> uploadFileAndSubmit(String assignmentId) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        String fileName = result.files.single.name;

        // Upload the file to Firebase Storage
        final fileRef = storage.ref().child('submissions/$assignmentId/$fileName');
        await fileRef.putFile(File(filePath));

        // Get the download URL
        String downloadUrl = await fileRef.getDownloadURL();

        // Save the submission in Firestore
        await firestore.collection('assignments').doc(assignmentId).collection('submitted').add({
          'email': state.email,
          'submissionDate': DateTime.now().toIso8601String(),
          'fileUrl': downloadUrl,
          'rating': '',
        });

        // Show success toast
        Fluttertoast.showToast(
          msg: "Assignment submitted successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "No file selected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error uploading file: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
