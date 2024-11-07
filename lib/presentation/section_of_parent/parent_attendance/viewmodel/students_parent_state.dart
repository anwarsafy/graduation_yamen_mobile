import 'package:equatable/equatable.dart';

class AttendanceStateParent extends Equatable {
  const AttendanceStateParent({
    this.attendanceData = const [],
    this.error,
  });

  final List<Map<String, dynamic>> attendanceData;
  final String? error;

  factory AttendanceStateParent.initial() {
    return const AttendanceStateParent();
  }

  AttendanceStateParent copyWith({
    List<Map<String, dynamic>>? attendanceData,
    String? error,
  }) {
    return AttendanceStateParent(
      attendanceData: attendanceData ?? this.attendanceData,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [attendanceData, error];
}