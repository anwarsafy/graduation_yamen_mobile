import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../task_manager/viewmodel/student_cubit.dart';
import '../../task_manager/viewmodel/student_state.dart';


class StudentScreen extends StatelessWidget {
  final String email;

  const StudentScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentCubit()..setEmail(email),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Student Assignments', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.indigo,
        ),
        body: BlocBuilder<StudentCubit, StudentState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildCalendar(context),
                Expanded(child: _buildAssignmentList(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Calendar Widget
  Widget _buildCalendar(BuildContext context) {
    final cubit = context.read<StudentCubit>();

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: SfCalendar(
        view: CalendarView.month,
        todayHighlightColor: Colors.indigo,
        selectionDecoration: BoxDecoration(
          color: Colors.indigo.withOpacity(0.3),
          border: Border.all(color: Colors.indigo, width: 2),
        ),
        onTap: (calendarTapDetails) {
          if (calendarTapDetails.date != null) {
            cubit.setSelectedDate(calendarTapDetails.date!);
          }
        },
      ),
    );
  }

  /// Assignment List Widget
  Widget _buildAssignmentList(BuildContext context, StudentState state) {
    if (state.assignments.isEmpty) {
      return const Center(
        child: Text(
          'No assignments for the selected date.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: state.assignments.length,
      itemBuilder: (context, index) {
        final assignment = state.assignments[index];
        return _buildAssignmentCard(context, assignment);
      },
    );
  }

  /// Card for displaying assignment details
  Widget _buildAssignmentCard(BuildContext context, Map<String, dynamic> assignment) {
    final cubit = context.read<StudentCubit>();

    // Format the date using DateFormat from the intl package
    String formattedDate = '';
    if (assignment['taskDate'] != null) {
      DateTime taskDate = assignment['taskDate'];
      formattedDate = DateFormat('dd-MM-yyyy hh:mm a').format(taskDate);
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assignment['courseName'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Type: ${assignment['taskType']}"),
            const SizedBox(height: 8),
            Text("Level: ${assignment['level']}"),
            const SizedBox(height: 8),
            Text("Department: ${assignment['department']}"),
            const SizedBox(height: 8),
            Text("Due Date: $formattedDate"), // Updated to show formatted date
            const SizedBox(height: 16),
            Text("Rating: ${assignment['rating'] ?? 'Not rated yet'}"),

            if (assignment['taskType'] != 'quiz' && assignment['taskType'] != 'exam')
              ElevatedButton.icon(
                onPressed: () => cubit.uploadFileAndSubmit(assignment['id']),
                icon: const Icon(Icons.upload_file, size: 20, color: Colors.white),
                label: const Text('Upload Assignment', style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
