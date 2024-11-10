import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_yamen_mobile/core/theme/colors.dart';
import 'package:graduation_yamen_mobile/core/widgets/loading_indicator.dart';
import 'package:intl/intl.dart';
import '../viewmodel/task_manger_cubit.dart';
import '../viewmodel/task_manger_state.dart';

class TeacherSubmissionScreen extends StatefulWidget {
  const TeacherSubmissionScreen({super.key});

  @override
  State<TeacherSubmissionScreen> createState() => _TeacherSubmissionScreenState();
}

class _TeacherSubmissionScreenState extends State<TeacherSubmissionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AssignmentCubit()..fetchAllSubmissions(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("All Student Submissions", style: TextStyle(color: Colors.white)),
          backgroundColor: ColorsManager.blue,
        ),
        body: BlocBuilder<AssignmentCubit, AssignmentState>(
          builder: (context, state) {
            if (state.isLoading) {
              return  Center(child: loadingIndicator());
            }

            if (state.submissions.isEmpty) {
              return const Center(child: Text('No submissions found.'));
            }

            return ListView.builder(
              itemCount: state.submissions.length,
              itemBuilder: (context, index) {
                final submission = state.submissions[index];
                return _buildSubmissionCard(context, submission);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubmissionCard(
      BuildContext context, Map<String, dynamic> submission) {
    final cubit = context.read<AssignmentCubit>();
    final TextEditingController ratingController = TextEditingController(
      text: submission['rating'] ?? '',
    );

    // Format the submission date
    String formattedDate = '';
    if (submission['submissionDate'] != null) {
      DateTime submissionDate = DateTime.parse(submission['submissionDate']);
      formattedDate = DateFormat('dd-MM-yyyy hh:mm a').format(submissionDate);
    }

    return Card(
      margin: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Student: ${submission['email']}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Submitted on: $formattedDate"),
            const SizedBox(height: 8),
            SelectableText('File URL: ${submission['fileUrl']}'),
            const SizedBox(height: 12),
            TextField(
              controller: ratingController,
              decoration: InputDecoration(
                labelText: 'Enter Rating',
                hintText: 'e.g., 5',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (ratingController.text.isNotEmpty) {
                  cubit.updateRating(
                    submission['assignmentId'],
                    submission['submissionId'],
                    ratingController.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rating submitted successfully!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Submit Rating', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }


}
