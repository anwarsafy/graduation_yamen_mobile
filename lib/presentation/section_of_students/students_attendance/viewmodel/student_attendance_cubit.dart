import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import '../../../section_of_teacher/teacher_attendance/model/teacher_attendance_model.dart';
import '../model/student_attendance_model.dart';
import 'student_attendance_state.dart';



class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceState()) {
    fetchAttendanceData();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchAttendanceData() async {
    emit(state.copyWith(status: AttendanceStatus.loading));

    try {
      String userId = _auth.currentUser?.uid ?? 'defaultUserId';
      QuerySnapshot attendanceSnapshot = await _firestore
          .collection('attendance')
          .where('userId', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> attendanceRecords = [];

      for (var doc in attendanceSnapshot.docs) {
        var attendanceData = doc.data() as Map<String, dynamic>;
        String qrID = attendanceData['qrID'];

        // Fetch related QR code data
        QRData qrCodeData = await getQRCodeData(qrID);

        attendanceRecords.add({
          ...attendanceData,
          'qrCodeData': qrCodeData.toMap(),
        });
      }

      emit(state.copyWith(status: AttendanceStatus.success, attendanceRecords: attendanceRecords));
    } catch (e) {
      emit(state.copyWith(status: AttendanceStatus.error, errorMessage: e.toString()));
    }
  }

  Future<QRData> getQRCodeData(String qrID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('qr_codes')
        .where('qrID', isEqualTo: qrID)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assuming there's only one document with this qrID
      DocumentSnapshot qrCodeDoc = querySnapshot.docs.first;
      return QRData.fromMap(qrCodeDoc.data() as Map<String, dynamic>);
    } else {
      throw Exception("QR code data not found for qrID: $qrID");
    }
  }

  Future<void> processAttendance(String qrID) async {
    emit(state.copyWith(status: AttendanceStatus.scanning));

    try {
      String macAddress = await _getMacAddress();
      User? user = _auth.currentUser;

      if (user == null) {
        emit(state.copyWith(status: AttendanceStatus.error, errorMessage: 'User not authenticated.'));
        return;
      }

      AttendanceData attendanceData = AttendanceData(
        email: user.email ?? '',
        userId: user.uid,
        attendanceTime: DateTime.now(),
        macAddress: macAddress,
        qrID: qrID, // Use the qrID from the scanned QR code
      );

      await _firestore.collection('attendance').add(attendanceData.toMap());

      emit(state.copyWith(status: AttendanceStatus.success));
    } catch (e) {
      emit(state.copyWith(status: AttendanceStatus.error, errorMessage: e.toString()));
    }
  }

  Future<String> _getMacAddress() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.hardware;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown';
    }
    return 'unknown';
  }
}