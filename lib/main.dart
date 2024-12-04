import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/data/notes_repo_impl.dart';
import 'package:flutter_notes/presentation/notes_cubit.dart';
import 'package:flutter_notes/presentation/notes_page.dart';
import 'package:flutter_notes/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseService = DatabaseService.instance;
  final notesRepository = NotesRepoImpl(databaseService);
  runApp(
    BlocProvider(
      create: (context) => NotesCubit(notesRepository)..loadNotes(),
      child: MyApp(notesRepoImpl: notesRepository),
    ),
  );
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final databaseService = DatabaseService.instance;
//   final notesRepository = NotesRepoImpl(databaseService);
//   runApp(MyApp(notesRepoImpl: notesRepository));
// }

class MyApp extends StatelessWidget {
  final NotesRepoImpl notesRepoImpl;
  const MyApp({super.key, required this.notesRepoImpl});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesPage(notesRepo: notesRepoImpl),
    );
  }
}
