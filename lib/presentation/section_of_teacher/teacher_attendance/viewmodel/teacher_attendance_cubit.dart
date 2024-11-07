import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_teacher/teacher_attendance/viewmodel/teacher_attendance_state.dart';

import '../model/teacher_attendance_model.dart';

class QRCodeCubit extends Cubit<QRCodeState> {
  QRCodeCubit() : super(QRCodeState());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> generateQRCode(QRData qrData) async {
    try {
      emit(state.copyWith(status: QRCodeStatus.generating));

      // Add QR data to Firebase
      DocumentReference docRef = await _firestore.collection('qr_codes').add(qrData.toMap());

      // Update state with new QRData
      List<QRData> updatedList = List.from(state.qrDataList)..add(qrData);
      emit(state.copyWith(status: QRCodeStatus.generated, qrDataList: updatedList));

      // Remove document after ten seconds
      Future.delayed(const Duration(minutes: 5), () async {
        await docRef.delete();
        updatedList.removeWhere((data) => data.qrID == qrData.qrID);
        emit(state.copyWith(status: QRCodeStatus.idle, qrDataList: updatedList));
      });
    } catch (e) {
      emit(state.copyWith(status: QRCodeStatus.error));
    }
  }

  // Fetch QR data from Firebase
  Future<void> fetchQRCodeList() async {
    QuerySnapshot snapshot = await _firestore.collection('qr_codes').get();
    List<QRData> qrDataList = snapshot.docs.map((doc) => QRData.fromMap(doc.data() as Map<String, dynamic>)).toList();
    emit(state.copyWith(status: QRCodeStatus.generated, qrDataList: qrDataList));
  }

/// Function to get all student data that scanned a specific QR code
  Future<void> fetchTeacherAttendanceData() async {
    try {
      emit(state.copyWith(status: QRCodeStatus.loading));

      // Step 1: Fetch QR codes created by the teacher
      QuerySnapshot qrSnapshot = await _firestore
          .collection('qr_codes')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();

      // Collect all qrIDs generated by this teacher
      List<String> qrIds = qrSnapshot.docs.map((doc) => doc['qrID'].toString()).toList();

      if (qrIds.isEmpty) {
        emit(state.copyWith(status: QRCodeStatus.noRecords));
        return;
      }

      // Step 2: Fetch attendance records where qrID is in the list of teacher's qrIDs
      QuerySnapshot attendanceSnapshot = await _firestore
          .collection('attendance')
          .where('qrID', whereIn: qrIds)
          .get();

      List<StudentAttendanceData> attendanceData = attendanceSnapshot.docs.map((doc) {
        return StudentAttendanceData.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      emit(state.copyWith(status: QRCodeStatus.attendanceLoaded, attendanceList: attendanceData));
    } catch (e) {
      emit(state.copyWith(status: QRCodeStatus.error));
    }
  }


  Future<void> deleteQRCode(String qrID) async {
    try {
      // Find and delete the QR code document from Firebase
      QuerySnapshot snapshot = await _firestore.collection('qr_codes').where('qrID', isEqualTo: qrID).get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Update state by removing the deleted QR code
      List<QRData> updatedList = List.from(state.qrDataList)..removeWhere((data) => data.qrID == qrID);
      emit(state.copyWith(status: QRCodeStatus.idle, qrDataList: updatedList));
    } catch (e) {
      emit(state.copyWith(status: QRCodeStatus.error));
    }
  }

  Future<void> addAttendance(String qrID, List<StudentAttendanceData> students) async {
    try {
      for (var student in students) {
        // Update attendance record for each selected student
        await _firestore.collection('attendance').add({
          'attendanceTime': DateTime.now().toIso8601String(),
          'email': student.email,
          'macAddress': "from teacher",
          'qrID': qrID,
          'userId': student.userId,
        });
      }

      emit(state.copyWith(status: QRCodeStatus.attendanceLoaded));
    } catch (e) {
      emit(state.copyWith(status: QRCodeStatus.error));
    }
  }


  // Fetch student list
  Future<void> fetchStudents() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('userType', isEqualTo: 'student')
          .get();

      List<StudentAttendanceData> students = snapshot.docs.map((doc) {
        return StudentAttendanceData(
          email: doc['email'],
          userId: doc['userId'],
          attendanceTime: '',
          macAddress: '',
          qrID: '',
        );
      }).toList();

      emit(state.copyWith(status: QRCodeStatus.studentsLoaded, students: students));
    } catch (e) {
      emit(state.copyWith(status: QRCodeStatus.error));
    }
  }
}
