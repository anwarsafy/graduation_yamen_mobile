import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../authentication/cubit/auth_cubit.dart';
import '../notes/view/teacher_notes_screen.dart';
import '../task_manger/view/task_manager_screen.dart';
import '../teacher_attendance/view/students_of_teacher_attendance.dart';
import '../teacher_attendance/view/teacher_attendance_screen.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
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
      mainScreen: MainTeacherScreen(
        onMenuPressed: () => _zoomDrawerController.toggle!(),
      ),
      menuScreen: const TeacherMenuScreen(),
    );
  }
}

class MainTeacherScreen extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const MainTeacherScreen({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Home"),
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

class TeacherMenuScreen extends StatelessWidget {
  const TeacherMenuScreen({super.key});

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
              'Teacher',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.qr_code, color: Colors.white),
            title: const Text('Generate QR Code', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRCodeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people, color: Colors.white),
            title: const Text('Students Attendance', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AttendanceScreenForStudentTeacher()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.note, color: Colors.white),
            title: const Text('Teacher Notes', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeacherNoteScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.task, color: Colors.white),
            title: const Text('Task Manager', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeacherScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
