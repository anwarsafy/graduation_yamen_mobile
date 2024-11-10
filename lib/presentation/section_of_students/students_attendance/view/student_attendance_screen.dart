// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduation_yamen_mobile/core/theme/theme_helper.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../viewmodel/student_attendance_cubit.dart';
import '../viewmodel/student_attendance_state.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  _StudentAttendanceScreenState createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.blue,
      appBar: AppBar(

        leading: IconButton(
          icon:  const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop( )
        ),
          backgroundColor: ColorsManager.blue,
          title:  const Text('Scan Attendance QR Code', style: TextStyle(color: Colors.white))),
      body: BlocProvider(
        create: (_) => AttendanceCubit(),
        child: BlocConsumer<AttendanceCubit, AttendanceState>(
          listener: (context, state) {
            if (state.status == AttendanceStatus.success) {
              Fluttertoast.showToast(
                  msg: 'Attendance recorded successfully',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (state.status == AttendanceStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.errorMessage ?? 'An error occurred')));
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  flex: 4,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: (controller) {
                      this.controller = controller;
                      controller.scannedDataStream.listen((scanData) {
                        context.read<AttendanceCubit>().processAttendance(scanData.code ?? '');
                        controller.pauseCamera();
                      });
                    },
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.red,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 300,
                    ),
                  ),
                ),


                if (state.status == AttendanceStatus.scanning)
                   loadingIndicator(),
                const SizedBox(height: 16),
                if (state.status == AttendanceStatus.error)
                  Text(state.errorMessage ?? 'Error', style: const TextStyle(color: Colors.red)),
              ],
            );
          },
        ),
      ),
    );
  }
}