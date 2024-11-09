import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/teacher_notes_model.dart';
import '../viewmodel/notes_cubit.dart';
import '../viewmodel/notes_state.dart';

class TeacherNoteScreen extends StatefulWidget {
  const TeacherNoteScreen({super.key});

  @override
  State<TeacherNoteScreen> createState() => _TeacherNoteScreenState();
}

class _TeacherNoteScreenState extends State<TeacherNoteScreen> {
  final TextEditingController _replyController = TextEditingController();
  bool _showAddNoteDialog = false;

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
          title: const Text('Teacher Notes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
          backgroundColor: Colors.indigo,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _showAddNoteDialog = true;
                });
              },
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        body: BlocBuilder<NoteCubit, NoteState>(
          builder: (context, state) {
            if (state.status == NoteStateStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == NoteStateStatus.error) {
              return Center(
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state.status == NoteStateStatus.success) {
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.notes!.length,
                itemBuilder: (context, index) {
                  Note note = state.notes![index];
                  return _buildNoteCard(context, note);
                },
              );
            } else {
              return const Center(child: Text('No notes found'));
            }
          },
        ),
        bottomSheet: _showAddNoteDialog
            ? AddNoteDialog(
          onNoteAdded: () {
            setState(() {
              _showAddNoteDialog = false;
            });
            context.read<NoteCubit>().fetchNotes();
          },
        )
            : null,
      ),
    );
  }

  /// Function to build a professional note card
  Widget _buildNoteCard(BuildContext context, Note note) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
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
  Widget _buildReplySection(BuildContext context, Note note) {
    return Column(
      children: [
        TextField(
          controller: _replyController,
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.black54),
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
            backgroundColor: Colors.indigo,
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
          child: const Text('Reply', style: TextStyle(color: Colors.white)),
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
          return const CircularProgressIndicator();
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
              : const Text('No replies yet');
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class AddNoteDialog extends StatefulWidget {
  final Function() onNoteAdded;

  const AddNoteDialog({super.key, required this.onNoteAdded});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final TextEditingController _noteController = TextEditingController();
  String? _selectedUser;

  final List<String> _dropdownOptions = ['All', 'All Students', 'All Parents', 'All Teachers'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(hintText: 'Enter note content'),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            hint: const Text('Assign to'),
            value: _selectedUser,
            items: _dropdownOptions.map((user) => DropdownMenuItem(value: user, child: Text(user))).toList(),
            onChanged: (value) => setState(() => _selectedUser = value),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              context.read<NoteCubit>().addNote(
                content: _noteController.text,
                assignedTo: _selectedUser ?? 'All',
              );
              _noteController.clear();
              widget.onNoteAdded();
            },
            child: const Text('Add Note'),
          ),
        ],
      ),
    );
  }
}
