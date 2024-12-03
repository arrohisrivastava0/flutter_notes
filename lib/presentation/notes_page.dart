import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/domain/repository/notes_repo.dart';
import 'package:flutter_notes/presentation/notes_cubit.dart';
import 'package:flutter_notes/presentation/notes_view.dart';

class NotesPage extends StatelessWidget {
  final NotesRepo notesRepo;
  const NotesPage({super.key, required this.notesRepo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> NotesCubit(notesRepo)..loadNotes(),
      child: NotesView(),

    );

  }
}