import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_yamen_mobile/presentation/authentication/cubit/auth_cubit.dart';

import '../parent_attendance/view/history.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parent Home")),
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
                'Parent',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Attendance History'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  const AttendanceScreenforParent()));
              },
            ),

          ],
        ),
      ),
    );
  }
}