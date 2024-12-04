import 'package:flutter/cupertino.dart';
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

  void createNewNote(BuildContext context, String title) {
    NotesModal newNote = NotesModal(
        id: DateTime.now().millisecondsSinceEpoch, title: title, body: '');
    goToNoteEditor(context, newNote, true);
  }

  void goToNoteEditor(BuildContext context, NotesModal note, bool isNew) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<NotesCubit>(),
          child: NoteEditorPage(notesModal: note, isNew: isNew),
        ),
      ),
    );
  }

  void _showNoteTitleAddBox(BuildContext context) {
    final textController = TextEditingController();
    final notesCubit = context.read<NotesCubit>();

    showDialog(context: context, builder: (context) =>
        AlertDialog(
          title: const Text('Add New Note'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'Enter note title'),
          ),
          actions: [
            //cancel
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel')
            ),
            //add
            TextButton(
                onPressed: () async {
                  if (textController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Title cannot be empty')),
                    );
                    return;
                  }
                  Navigator.of(context).pop();
                  final newNote= await notesCubit.addNote(textController.text.trim(), '');
                  // final newNote = NotesModal(
                  //   id: DateTime.now().millisecondsSinceEpoch,
                  //   title: textController.text.trim(),
                  //   body: '',
                  // );
                  goToNoteEditor(context, newNote, true)  ;
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
      backgroundColor: Colors.grey,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showNoteTitleAddBox(context);
        },
      ),
      body: BlocBuilder<NotesCubit, List<NotesModal>>(
        builder: (context, notes) {
          if (notes.isEmpty) {
            return const Center(child: Text('No notes available.'));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      tileColor: Colors.white,
                      title: Text(
                        note.title,
                      ),
                      subtitle: Text(
                        note.body.length > 50
                            ? '${note.body.substring(0, 50)}...'
                            : note.body,
                      ),
                      onTap: () {
                        goToNoteEditor(context, note, false);
                      },
                    ),
                  );
                }),
          );
        },
      ),
    );
  }

}
