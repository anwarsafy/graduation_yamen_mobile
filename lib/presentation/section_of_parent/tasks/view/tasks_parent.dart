import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../section_of_parent/tasks/viewmodel/parent_tasks_cubit.dart';
import '../../../section_of_parent/tasks/viewmodel/parent_tasks_state.dart';


class TasksScreenForParent extends StatelessWidget {
  const TasksScreenForParent({super.key});

  /// Format Date Function
  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm a');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksCubitParent()..fetchTasksData(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(' MY Children Tasks History', style: TextStyle(color: Colors.white, fontSize: 20)),
          backgroundColor: Colors.indigo,
        ),
        body: BlocBuilder<TasksCubitParent, TasksStateParent>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(child: _buildTaskList(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }


  /// Task List Widget
  Widget _buildTaskList(BuildContext context, TasksStateParent state) {
    if (state.error != null) {
      return Center(
        child: Text(
          state.error!,
          style: const TextStyle(color: Colors.red, fontSize: 18),
        ),
      );
    }

    if (state.tasksData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: state.tasksData.length,
      itemBuilder: (context, index) {
        final task = state.tasksData[index];
        return _buildTaskCard(context, task);
      },
    );
  }

  /// Task Card Widget
  Widget _buildTaskCard(BuildContext context, Map<String, dynamic> task) {
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
              "Course: ${task['courseName']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Department: ${task['department']}"),
            Text("Level: ${task['level']}"),
            const SizedBox(height: 8),
            Text("Task Type: ${task['taskType']}"),
            Text("Task Date: ${formatDate(task['taskDate'])}"),
            const SizedBox(height: 16),
            const Text("Submissions:", style: TextStyle(fontWeight: FontWeight.bold)),
            ...task['submissions'].map<Widget>((submission) {
              return ListTile(
                title: Text(submission['email']),
                subtitle: Text("Submitted on: ${formatDate(submission['submissionDate'])}"),
                trailing: Text("Rating: ${submission['rating']}"),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
