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

  Future<NotesModal> addNote(String title, String body)async {
    final newNote=NotesModal(id: DateTime.now().millisecondsSinceEpoch, title: title, body: body);
    await notesRepo.addNote(newNote);
    emit([...state, newNote]);
    return newNote;
  }

  Future<void> updateNote(int id, String title, String body)async {
    final updatedNote=NotesModal(id: id, title: title, body: body);
    await notesRepo.updateNote(updatedNote);
    // Update the note in the current state
    final updatedNotes = state.map((note) {
      return note.id == id ? updatedNote : note;
    }).toList();

    emit(updatedNotes);
  }

  Future<void> deleteNote(NotesModal notesModal)async {
    await notesRepo.deleteNote(notesModal);
    final updatedNotes = state.where((note) => note.id != notesModal.id).toList();
    emit(updatedNotes);
  }
}