import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_yamen_mobile/core/theme/colors.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_teacher/task_manger/view/submisstion.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../viewmodel/task_manger_cubit.dart';
import '../viewmodel/task_manger_state.dart';

class TeacherScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  TeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AssignmentCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("Assignment Manager",
              style: TextStyle(color: Colors.white)),
          backgroundColor:ColorsManager.blue,
          actions: [
            BlocBuilder<AssignmentCubit, AssignmentState>(
              builder: (context, state) {
                  return IconButton(
                    icon: const Icon(Icons.history, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TeacherSubmissionScreen(
                          ),
                        ),
                      );
                    },
                  );

              },
            ),
          ],
        ),
        body: Center(
          child: BlocBuilder<AssignmentCubit, AssignmentState>(
  builder: (context, state) {
    return ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              backgroundColor: ColorsManager.blue,
            ),
            onPressed: () => _showAddAssignmentDialog(context),
            child: const Text("Add Assignment", style: TextStyle(color: Colors.white)),
          );
  },
),
        ),
      ),
    );
  }

  /// Function to show dialog for adding an assignment
  void _showAddAssignmentDialog(BuildContext context) async {
    List<String> studentList = await _getStudents();
    List<MultiSelectItem<String>> studentItems = studentList
        .map((student) => MultiSelectItem(student, student))
        .toList();

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: context.read<AssignmentCubit>(),
        child: AlertDialog(
          title: const Text("Add Assignment"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Level"),
                    onChanged: context.read<AssignmentCubit>().setLevel,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Department"),
                    onChanged: context.read<AssignmentCubit>().setDepartment,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Course Name"),
                    onChanged: context.read<AssignmentCubit>().setCourseName,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        // ignore: use_build_context_synchronously
                        context.read<AssignmentCubit>().setTaskDate(date);
                      }
                    },
                    child: const Text("Select Task Date"),
                  ),
                  MultiSelectDialogField(
                    items: studentItems,
                    title: const Text("Select Students"),
                    onConfirm: (values) {
                      context.read<AssignmentCubit>().setSelectedStudents(
                          values.map((value) => value.toString()).toList());
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                context.read<AssignmentCubit>().addAssignment();
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }

  /// Fetches the list of students from Firestore
  Future<List<String>> _getStudents() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: 'student')
        .get();
    return snapshot.docs.map((doc) => doc['email'] as String).toList();
  }
}
