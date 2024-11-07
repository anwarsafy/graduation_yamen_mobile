import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../model/teacher_attendance_model.dart';
import '../viewmodel/teacher_attendance_cubit.dart';
import '../viewmodel/teacher_attendance_state.dart';
import 'students_of_teacher_attendance.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  List<String> selectedStudents = []; // Store selected students' IDs

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => QRCodeCubit()..fetchQRCodeList()..fetchStudents(),
  child: Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Generator'),
      ),
      body: BlocConsumer<QRCodeCubit, QRCodeState>(
        listener: (context, state) {
          if (state.status == QRCodeStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error generating QR code')));
          } else if (state.status == QRCodeStatus.deleted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('QR code deleted')));
          } else if (state.status == QRCodeStatus.attendanceSaved) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance saved for selected students')));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              ElevatedButton(
                onPressed: () => _showInputDialog(context),
                child: const Text('Add QR Code Data'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.qrDataList.length,
                  itemBuilder: (context, index) {
                    final qrData = state.qrDataList[index];
                    return ListTile(
                      title: Text('Doctor: ${qrData.doctorName}'),
                      subtitle: Text('Subject: ${qrData.subjectName}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.qr_code),
                            onPressed: () => _showQRCodeDialog(context, qrData),
                          ),
                          // IconButton(
                          //   icon: const Icon(Icons.delete),
                          //   onPressed: () {
                          //     context.read<QRCodeCubit>().deleteQRCode(qrData.qrID);
                          //   },
                          // ),
                          IconButton(
                            icon: const Icon(Icons.person_add),
                            onPressed: () => _showStudentAttendanceDialog(context, qrData),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    ),
);
  }

  void _showStudentAttendanceDialog(BuildContext context, QRData qrData) {
    // Use the dynamically loaded student data from the QRCodeCubit
    final students = context.read<QRCodeCubit>().state.students;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Students for Attendance'),
        content: MultiSelectDialogField<StudentAttendanceData>(
          items: students.map((student) => MultiSelectItem(student, student.email)).toList(),
          listType: MultiSelectListType.CHIP,
          onConfirm: (List<StudentAttendanceData> selectedStudents) {
            context.read<QRCodeCubit>().addAttendance(qrData.qrID, selectedStudents);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }


  void _showInputDialog(BuildContext context) async {
    final doctorController = TextEditingController();
    final subjectController = TextEditingController();
    final levelController = TextEditingController();

    // Request location permissions
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission denied')));
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: doctorController,
              decoration: const InputDecoration(labelText: 'Doctor Name'),
            ),
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: 'Subject Name'),
            ),
            TextField(
              controller: levelController,
              decoration: const InputDecoration(labelText: 'Level Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              String doctorName = doctorController.text;
              String subjectName = subjectController.text;
              String levelName = levelController.text;
              String location = '${position.latitude},${position.longitude}';
              String userId = FirebaseAuth.instance.currentUser!.uid;
              String email = FirebaseAuth.instance.currentUser!.email!;
              String qrID = DateTime.now().millisecondsSinceEpoch.toString(); // Generate unique ID for each QR

              QRData qrData = QRData(
                doctorName: doctorName,
                subjectName: subjectName,
                levelName: levelName,
                location: location,
                userId: userId,
                email: email,
                qrID: qrID,
              );

              BlocProvider.of<QRCodeCubit>(context).generateQRCode(qrData);
              _showQRCodeDialog(context, qrData); // Show QR code dialog after generating
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _showQRCodeDialog(BuildContext context, QRData qrData) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'QR Code Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                QrImageView(
                  data: qrData.qrID,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 20),
                _buildInfoRow('Doctor Name', qrData.doctorName),
                _buildInfoRow('Subject Name', qrData.subjectName),
                _buildInfoRow('Level Name', qrData.levelName),
                _buildInfoRow('Location', qrData.location),
                _buildInfoRow('User ID', qrData.userId),
                _buildInfoRow('Email', qrData.email),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

}
