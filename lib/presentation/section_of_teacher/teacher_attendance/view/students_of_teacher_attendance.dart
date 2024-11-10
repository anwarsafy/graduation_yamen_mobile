import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/colors.dart';
import '../viewmodel/teacher_attendance_cubit.dart';
import '../viewmodel/teacher_attendance_state.dart';

class AttendanceScreenForStudentTeacher extends StatelessWidget {
  const AttendanceScreenForStudentTeacher({super.key});

  // Helper function to format the date
  String formatDate(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd-MM-yyyy h:mma').format(dateTime);
    } catch (e) {
      return dateTimeString; // If parsing fails, return the original string
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.blue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Student Attendance', style: TextStyle(color: Colors.white)),
        ),
      body: BlocProvider(
        create: (_) => QRCodeCubit()..fetchTeacherAttendanceData(),
        child: BlocBuilder<QRCodeCubit, QRCodeState>(
          builder: (context, state) {
            if (state.status == QRCodeStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == QRCodeStatus.error) {
              return const Center(child: Text('Error fetching attendance data'));
            } else if (state.status == QRCodeStatus.noRecords || state.attendanceList.isEmpty) {
              return const Center(child: Text('No attendance records found'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: state.attendanceList.length,
                  itemBuilder: (context, index) {
                    final attendanceData = state.attendanceList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  attendanceData.email,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(Icons.email, color: Colors.orange),
                              ],
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Attendance Time: ${formatDate(attendanceData.attendanceTime)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'MAC Address: ${attendanceData.macAddress}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Image.asset('assets/glogo.png', width: 50, height: 50),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'QR ID: ${attendanceData.qrID}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'User ID: ${attendanceData.userId}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
