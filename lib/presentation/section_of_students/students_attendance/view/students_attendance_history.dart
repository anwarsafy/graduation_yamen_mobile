import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_yamen_mobile/core/theme/theme_helper.dart';
import 'package:graduation_yamen_mobile/core/widgets/loading_indicator.dart';

import '../viewmodel/student_attendance_cubit.dart';
import '../viewmodel/student_attendance_state.dart';


// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduation_yamen_mobile/core/theme/theme_helper.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../../core/widgets/loading_indicator.dart';
import '../viewmodel/student_attendance_cubit.dart';
import '../viewmodel/student_attendance_state.dart';

class AttendanceTableScreen extends StatefulWidget {
  const AttendanceTableScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceTableScreen> createState() => _AttendanceTableScreenState();
}

class _AttendanceTableScreenState extends State<AttendanceTableScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendanceCubit()..fetchAttendanceData(),
      child: Scaffold(
        backgroundColor: appTheme.black,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: appTheme.whiteA700),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: appTheme.black,
          title: Text("Attendance Records", style: TextStyle(color: appTheme.whiteA700)),
        ),
        body: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            if (state.status == AttendanceStatus.loading) {
              return  Center(child: loadingIndicator());
            } else if (state.status == AttendanceStatus.error) {
              return Center(child: Text("Error: ${state.errorMessage}"));
            } else if (state.status == AttendanceStatus.success) {
              return _buildAttendanceList(state.attendanceRecords);
            }
            return const Center(child: Text("No data available."));
          },
        ),
      ),
    );
  }

  Widget _buildAttendanceList(List<Map<String, dynamic>> attendanceRecords) {
    return ListView.builder(
      itemCount: attendanceRecords.length,
      itemBuilder: (context, index) {
        final record = attendanceRecords[index];
        final qrCodeData = record['qrCodeData'] ?? {};

        return Card(
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("User: ${record['email'] ?? ''}"),
              ],
            ),
            subtitle: Text("Subject: ${qrCodeData['subjectName'] ?? 'Unknown'}"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  children: [
                    _buildTableRow("Doctor Name", qrCodeData['doctorName'] ?? 'N/A'),
                    _buildTableRow("Level Name", qrCodeData['levelName'] ?? 'N/A'),
                    _buildTableRow("Location", qrCodeData['location'] ?? 'N/A'),
                    _buildTableRow("Subject Name", qrCodeData['subjectName'] ?? 'N/A'),
                    _buildTableRow("MAC Address", record['macAddress'] ?? 'N/A'),
                    _buildTableRow("QR ID", record['qrID'] ?? 'N/A'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
