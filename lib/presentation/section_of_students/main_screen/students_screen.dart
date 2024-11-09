import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_yamen_mobile/presentation/authentication/cubit/auth_cubit.dart';

import '../notes/view/students_note_screen.dart';
import '../students_attendance/view/student_attendance_screen.dart';
import '../students_attendance/view/students_attendance_history.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Home")),
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
                'Student',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Attendance'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentAttendanceScreen()));
              },
            ),
            ListTile(
              title: const Text('Attendance History'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>   const AttendanceTableScreen()));
              },
            ),
            ListTile(
              title: const Text('Notes'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>    const NoteScreen(userType: 'student',)));
              },
            ),
]
        ),
      ),
    );
  }
}
