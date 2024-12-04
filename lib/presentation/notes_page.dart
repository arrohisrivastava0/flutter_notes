import 'package:flutter/cupertino.dart';
import 'package:flutter_notes/domain/repository/notes_repo.dart';
import 'package:flutter_notes/presentation/notes_view.dart';

class NotesPage extends StatelessWidget {
  final NotesRepo notesRepo;

  const NotesPage({super.key, required this.notesRepo});

  @override
  Widget build(BuildContext context) {
    return const NotesView(); // Directly return NotesView
  }
}
