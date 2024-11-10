import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:graduation_yamen_mobile/presentation/authentication/cubit/auth_cubit.dart';

import '../../../core/theme/colors.dart';
import '../note/view/parents_notes_screen.dart';
import '../parent_attendance/view/history.dart';
import '../tasks/view/tasks_parent.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
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
      menuBackgroundColor: ColorsManager.blue,
      mainScreen: MainScreen(
        onMenuPressed: () => _zoomDrawerController.toggle!(),
      ),
      menuScreen: const MenuScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const MainScreen({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Home"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onMenuPressed,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/glogo.png'),
            ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(ColorsManager.blue,),
              ),
              onPressed: () {
                context.read<AuthCubit>().signOut();
              },
              child: const Text("Sign Out", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.blue,
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: ColorsManager.blue,
            ),
            child: Text(
              'Parent',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.white),
            title: const Text('Attendance History', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AttendanceScreenforParent()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.note, color: Colors.white),
            title: const Text('Notes', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ParentNoteScreen(userType: 'parent')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.task, color: Colors.white),
            title: const Text('Tasks', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TasksScreenForParent()),
              );
            },
          ),
        ],
      ),
    );
  }
}
