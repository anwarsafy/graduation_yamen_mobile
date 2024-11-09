import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authentication/cubit/auth_cubit.dart';
import '../notes/view/teacher_notes_screen.dart';
import '../teacher_attendance/view/students_of_teacher_attendance.dart';
import '../teacher_attendance/view/teacher_attendance_screen.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: const Text("Teacher Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthCubit>().signOut();
          },
          child: const Text("Sign Out"),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Text(
                'Teacher',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Generate QR Code'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QRCodeScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Students Attendance'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AttendanceScreenForStudentTeacher(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Teacher Notes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeacherNoteScreen(),
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
