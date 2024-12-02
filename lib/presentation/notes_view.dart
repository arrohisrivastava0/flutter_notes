import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/domain/modal/notes_modal.dart';
import 'package:flutter_notes/presentation/notes_cubit.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  void showNoteEditor(BuildContext context){
    final textController=TextEditingController();
    final noteCubit=context.read<NotesCubit>();

  }

  @override
  Widget build(BuildContext context) {
    final notesCubit=context.read<NotesCubit>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {

        },
      ),
      body: BlocBuilder<NotesCubit, List<NotesModal>>(
        builder: (context, notes) {
          return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index){
                final note=notes[index];
                return ListTile(
                  title: Text(
                    note.title,
                  ),
                  subtitle: Text(
                    _clipNoteBody(note.body, 50),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }
          );
        },

      ),
    );
  }

  String _clipNoteBody(String body, int charLimit) {
    if (body.length <= charLimit) return body; // If within the limit, return as is
    return body.substring(0, charLimit) + '...'; // Take the first few characters and add "..."
  }

}
