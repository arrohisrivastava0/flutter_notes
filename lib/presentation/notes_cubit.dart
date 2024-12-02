import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/domain/modal/notes_modal.dart';

import '../domain/repository/notes_repo.dart';

class NotesCubit extends Cubit<List<NotesModal>>{
  final NotesRepo notesRepo;
  NotesCubit(this.notesRepo): super([]);

  Future<void> loadNotes()async {
    final notes=await notesRepo.getNotes();
    emit(notes);
  }

  Future<void> addNote(String title, String body)async {
    final newNote=NotesModal(id: DateTime.now().millisecondsSinceEpoch, title: title, body: body);
    await notesRepo.addNote(newNote);
    loadNotes();

  }

  Future<void> updateNote(String title, String body)async {
    final updatedNote=NotesModal(id: DateTime.now().millisecondsSinceEpoch, title: title, body: body);
    await notesRepo.updateNote(updatedNote);
    loadNotes();
  }

  Future<void> deleteNote(NotesModal notesModal)async {
    await notesRepo.deleteNote(notesModal);
    loadNotes();
  }
}