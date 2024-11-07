import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_parent/parent_attendance/viewmodel/students_parent_cubit.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_parent/parent_attendance/viewmodel/students_parent_state.dart';

import 'package:intl/intl.dart';

class AttendanceScreenforParent extends StatelessWidget {
  const AttendanceScreenforParent({super.key});

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('d-M-yyyy h:mma');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendanceCubitParent()..fetchAttendanceData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Children Attendance History',
              style: TextStyle(fontSize: 17)),
          centerTitle: true,
        ),
        body: BlocBuilder<AttendanceCubitParent, AttendanceStateParent>(
          builder: (context, state) {
            if (state.error != null) {
              return Center(
                child: Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            }

            if (state.attendanceData.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: state.attendanceData.length,
              itemBuilder: (context, index) {
                final attendanceRecord = state.attendanceData[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          attendanceRecord['email'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Attendance Time:",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              formatDate(attendanceRecord['attendanceTime']),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.teal[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "QR Code ID:",
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                            Text(
                              attendanceRecord['qrID'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.teal[800],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
