import '../model/teacher_attendance_model.dart';

enum QRCodeStatus { idle, generating, generated, error, loading, attendanceLoaded, noRecords, deleted, attendanceSaved, studentsLoaded }

class QRCodeState {
  final QRCodeStatus status;
  final List<QRData> qrDataList;
  final List<StudentAttendanceData> attendanceList; // New field for attendance data
  final List<StudentAttendanceData> students; // New field for attendance data

  QRCodeState({
    this.status = QRCodeStatus.idle,
    this.qrDataList = const [],
    this.attendanceList = const [], // Initialize attendance data
    this.students = const [], // Initialize attendance data
  });

  QRCodeState copyWith({
    QRCodeStatus? status,
    List<QRData>? qrDataList,
    List<StudentAttendanceData>? attendanceList, // Add copy for attendance data
    List<StudentAttendanceData>? students, // Add copy for attendance data
  }) {
    return QRCodeState(
      status: status ?? this.status,
      qrDataList: qrDataList ?? this.qrDataList,
      attendanceList: attendanceList ?? this.attendanceList,
      students: students ?? this.students,
    );
  }
}

class StudentAttendanceData {
  final String attendanceTime;
  final String email;
  final String macAddress;
  final String qrID;
  final String userId;


  StudentAttendanceData({
    required this.attendanceTime,
    required this.email,
    required this.macAddress,
    required this.qrID,
    required this.userId,
  });

  factory StudentAttendanceData.fromMap(Map<String, dynamic> map) {
    return StudentAttendanceData(
      attendanceTime: map['attendanceTime'] ?? '',
      email: map['email'] ?? '',
      macAddress: map['macAddress'] ?? '',
      qrID: map['qrID'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  // Method to convert StudentAttendanceData to Map for Firebase operations
  Map<String, dynamic> toMap() {
    return {
      'attendanceTime': attendanceTime,
      'email': email,
      'macAddress': macAddress,
      'qrID': qrID,
      'userId': userId,
    };
  }
}
