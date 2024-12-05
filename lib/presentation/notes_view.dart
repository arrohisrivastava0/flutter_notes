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

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add New Note'),
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(hintText: 'Enter note title'),
              ),
              actions: [
                //cancel
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel')),
                //add
                TextButton(
                    onPressed: () async {
                      if (textController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Title cannot be empty')),
                        );
                        return;
                      }
                      Navigator.of(context).pop();
                      final newNote = await notesCubit.addNote(
                          textController.text.trim(), '');
                      goToNoteEditor(context, newNote, true);
                    },
                    child: const Text('Add'))
              ],
            ));
  }

  void deleteNotes(NotesModal note) {}

  @override
  Widget build(BuildContext context) {
    final notesCubit = context.read<NotesCubit>();
    final isSelectionMode = notesCubit.selectionMode;
    final selectedCount = notesCubit.selectedNoteIds.length;
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: BlocBuilder<NotesCubit, List<NotesModal>>(
          builder: (context, notes) {
            final isSelectionMode = context.read<NotesCubit>().selectionMode;
            return Text(isSelectionMode ? 'Select Notes' : 'Notes');
          },
        ),
        actions: [
          BlocBuilder<NotesCubit, List<NotesModal>>(
            builder: (context, notes) {
              final isSelectionMode = context.read<NotesCubit>().selectionMode;
              return IconButton(
                icon: Icon(isSelectionMode ? Icons.select_all : Icons.delete),
                onPressed: () {

                  context.read<NotesCubit>().toggleSelectionMode();
                },
              );
            },
          ),


          // if (isSelectionMode) ...[
          //   IconButton(
          //     icon: Icon(Icons.select_all),
          //     onPressed: notesCubit.selectedNoteIds.length == notes.length
          //         ? notesCubit.deselectAllNotes
          //         : notesCubit.selectAllNotes,
          //   ),
          // ] else ...[
          //   IconButton(
          //     icon: Icon(Icons.delete),
          //     onPressed: notesCubit.toggleSelectionMode,
          //   ),
          // ],
        ],
      ),
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
                  final isSelected = context.read<NotesCubit>().selectedNoteIds.contains(note.id);
                  // final isSelected =
                  //     notesCubit.selectedNoteIds.contains(note.id);
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      tileColor: Colors.white,
                      title: Text(
                        note.title,
                      ),
                      subtitle: Text(
                        note.body.length > 50
                            ? '${note.body.substring(0, 50)}...'
                            : note.body,
                      ),
                      leading: notesCubit.selectionMode
                          ? Checkbox(
                              value: isSelected,
                              onChanged: (_) =>
                                  notesCubit.toggleNoteSelection(note.id),
                            )
                          : null,
                      onTap: context.read<NotesCubit>().selectionMode
                          ? () => context.read<NotesCubit>().toggleNoteSelection(note.id)
                          : () {
                              // notesCubit.deleteNote(note);
                              context.read<NotesCubit>().loadNotes();
                              goToNoteEditor(context, note, false);
                            },
                    ),
                  );
                }),
          );
        },
      ),
        bottomSheet: notesCubit.selectionMode
            ? BottomAppBar(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: notesCubit.toggleSelectionMode,
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (context.read<NotesCubit>().selectedNoteIds.isNotEmpty) {
                        final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: const Text(
                                    'Are you sure you want to delete the selected notes?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Yes'),
                                    ),
                                  ]);
                            });
                        if (confirmed == true) {
                          await context.read<NotesCubit>().deleteSelectedNotes();
                          context.read<NotesCubit>().toggleSelectionMode(); // Exit selection mode
                        }
                      }
                    },
                    child: const Text('Delete Selected'),
                  )
                ])): null,
    );
  }
}
