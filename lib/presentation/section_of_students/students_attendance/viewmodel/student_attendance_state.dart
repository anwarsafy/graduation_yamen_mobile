enum AttendanceStatus { idle, scanning, success, error, loading }

class AttendanceState {
  final AttendanceStatus status;
  final String? errorMessage;
  final List<Map<String, dynamic>> attendanceRecords; // Holds multiple attendance entries
  final Map<String, dynamic> qrCodeData; // Holds QR code data if fetched independently

  AttendanceState({
    this.status = AttendanceStatus.idle,
    this.errorMessage,
    this.attendanceRecords = const [],
    this.qrCodeData = const {}, // Default to an empty map to avoid null
  });

  AttendanceState copyWith({
    AttendanceStatus? status,
    String? errorMessage,
    List<Map<String, dynamic>>? attendanceRecords,
    Map<String, dynamic>? qrCodeData,
  }) {
    return AttendanceState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      attendanceRecords: attendanceRecords ?? this.attendanceRecords,
      qrCodeData: qrCodeData ?? this.qrCodeData,
    );
  }
}
