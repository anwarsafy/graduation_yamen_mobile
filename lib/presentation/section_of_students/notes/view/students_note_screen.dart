import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_yamen_mobile/core/theme/colors.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_students/notes/viewmodel/students_notes_cubit.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_students/notes/viewmodel/students_notes_state.dart';
import '../model/students_note_model.dart';

class NoteScreen extends StatefulWidget {
  final String userType;

  const NoteScreen({super.key, required this.userType});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteCubit()..fetchNotes(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(

          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '${widget.userType} Notes',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ),
          backgroundColor: ColorsManager.blue,
        ),
        body: BlocBuilder<NoteCubit, NoteStateUS>(
          builder: (context, state) {
            if (state.status == NoteStateStatusUS.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == NoteStateStatusUS.error) {
              return Center(
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state.status == NoteStateStatusUS.success) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: state.notes!.length,
                      itemBuilder: (context, index) {
                        NoteUS note = state.notes![index];

                        if (note.assignedTo == 'All Students' ||
                            note.assignedTo == 'All' ||
                            note.assignedTo == FirebaseAuth.instance.currentUser!.email) {
                          return _buildNoteCard(context, note);
                        } else {
                          return const SizedBox.shrink(); // Hide irrelevant notes
                        }
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No notes found'));
            }
          },
        ),
      ),
    );
  }

  /// Function to build a professional note card
  Widget _buildNoteCard(BuildContext context, NoteUS note) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${note.authorName} - ${note.content}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Assigned to: ${note.assignedTo ?? 'None'}',
              style: const TextStyle(color: Colors.black54),
            ),
            const Divider(height: 20, color: Colors.grey),
            _buildReplySection(context, note),
            _buildRepliesList(note.id),
          ],
        ),
      ),
    );
  }

  /// Function to build the reply section
  Widget _buildReplySection(BuildContext context, NoteUS note) {
    return Column(
      children: [
        TextField(
          controller: _replyController,
          decoration: InputDecoration(
            hintText: 'Add your reply...',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
          onPressed: () {
            if (_replyController.text.isNotEmpty) {
              context.read<NoteCubit>().addReply(
                noteId: note.id,
                replyContent: _replyController.text,
              );
              _replyController.clear();
            }
          },
          child: const Text(
            'Reply',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  /// Function to display the list of replies
  Widget _buildRepliesList(String noteId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notes')
          .doc(noteId)
          .collection('replies')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> replies = snapshot.data!.docs;
          return replies.isNotEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: replies.map((reply) {
              return Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${reply['authorName']}: ${reply['content']}',
                  style: const TextStyle(color: Colors.black87),
                ),
              );
            }).toList(),
          )
              : const Text('No replies yet', style: TextStyle(color: Colors.black54));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
