import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/domain/modal/notes_modal.dart';
import 'package:flutter_notes/presentation/notes_cubit.dart';
import 'package:path/path.dart';

import 'note_editor_page.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  List<Map<String, String>> notes = [];

  void createNewNote(String title) {
    NotesModal newNote = NotesModal(
        id: DateTime.now().millisecondsSinceEpoch, title: title, body: '');
    goToNoteEditor(newNote, true);
  }

  void goToNoteEditor(NotesModal note, bool isNew) {
    Navigator.push(
        context as BuildContext,
        MaterialPageRoute(
            builder: (context) =>
                NoteEditorPage(notesModal: note, isNew: isNew)));
  }

  String _clipNoteBody(String body, int charLimit) {
    if (body.length <= charLimit)
      return body; // If within the limit, return as is
    return '${body.substring(0, charLimit)}...'; // Take the first few characters and add "..."
  }

  void _showTodoAddBox(BuildContext context) {
    final textController = TextEditingController();
    // final notesCubit = context.read<NotesCubit>();

    showDialog(context: context, builder: (context) =>
        AlertDialog(
          content: TextField(controller: textController,),
          actions: [
            //cancel
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel')
            ),
            //add
            TextButton(
                onPressed: () {
                  createNewNote(textController.text);
                },
                child: const Text('Add')
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final notesCubit = context.read<NotesCubit>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showTodoAddBox(context);
        },
      ),
      body: BlocBuilder<NotesCubit, List<NotesModal>>(
        builder: (context, notes) {
          return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(
                    note.title,
                  ),
                  subtitle: Text(
                    _clipNoteBody(note.body, 50),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    goToNoteEditor(note, false);
                  },
                );
              });
        },
      ),
    );
  }

}
