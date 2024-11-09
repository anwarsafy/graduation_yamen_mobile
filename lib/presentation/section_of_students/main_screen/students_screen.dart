import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:graduation_yamen_mobile/presentation/authentication/cubit/auth_cubit.dart';

import '../notes/view/students_note_screen.dart';
import '../students_attendance/view/student_attendance_screen.dart';
import '../students_attendance/view/students_attendance_history.dart';
import '../task_manager/view/student_task_manger.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final ZoomDrawerController _zoomDrawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _zoomDrawerController,
      borderRadius: 24.0,
      showShadow: true,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      menuScreenTapClose: true,
      duration: const Duration(milliseconds: 400),
      menuBackgroundColor: Colors.blueGrey,
      mainScreen: MainStudentScreen(
        onMenuPressed: () => _zoomDrawerController.toggle!(),
      ),
      menuScreen: const StudentMenuScreen(),
    );
  }
}

class MainStudentScreen extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const MainStudentScreen({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Home"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onMenuPressed,
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthCubit>().signOut();
          },
          child: const Text("Sign Out"),
        ),
      ),
    );
  }
}

class StudentMenuScreen extends StatelessWidget {
  const StudentMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: ListView(
        padding: const EdgeInsets.all(8.0),
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
            leading: const Icon(Icons.assignment, color: Colors.white),
            title: const Text('Attendance', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StudentAttendanceScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.white),
            title: const Text('Attendance History', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AttendanceTableScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.note, color: Colors.white),
            title: const Text('Notes', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NoteScreen(userType: 'student')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.task, color: Colors.white),
            title: const Text('Tasks', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StudentScreen(
                        email: FirebaseAuth.instance.currentUser!.email!)),
              );
            },
          ),
        ],
      ),
    );
  }
}
