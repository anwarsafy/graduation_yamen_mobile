class AttendanceData {
  final String email;
  final String userId;
  final DateTime attendanceTime;
  final String macAddress;
  final String qrID; // The data from the scanned QR code

  AttendanceData({
    required this.email,
    required this.userId,
    required this.attendanceTime,
    required this.macAddress,
    required this.qrID,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'userId': userId,
      'attendanceTime': attendanceTime.toIso8601String(),
      'macAddress': macAddress,
      'qrID': qrID, // Added qrID to the map for Firebase
    };
  }
}
