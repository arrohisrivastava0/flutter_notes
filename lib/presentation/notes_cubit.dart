import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/domain/modal/notes_modal.dart';

import '../domain/repository/notes_repo.dart';

class NotesCubit extends Cubit<List<NotesModal>>{
  final NotesRepo notesRepo;
  bool selectionMode = false; // Track if selection mode is active
  Set<int> selectedNoteIds = {};
  NotesCubit(this.notesRepo): super([]);

  Future<void> loadNotes()async {
    final notes=await notesRepo.getNotes();
    print('Loaded notes: $notes');
    emit(notes);
  }

  Future<NotesModal> addNote(String title, String body)async {
    final newNote=NotesModal(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        body: body
    );
    await notesRepo.addNote(newNote);
    emit([...state, newNote]);
    return newNote;
  }

  Future<void> updateNote(int id, String title, String body)async {
    final updatedNote=NotesModal(id: id, title: title, body: body);
    print('Updating note in cubit: $updatedNote');
    await notesRepo.updateNote(updatedNote);
    final updatedNotes = state.map((note) {
      if (note.id == id) {
        return NotesModal(id: id, title: title, body: body);
      }
      return note;
    }).toList();
    print("Before emitting updated state: $updatedNotes");
    emit([...state, updatedNote]);
    print("After emitting updated state"); // Emit the updated state

  }

  // Toggle selection mode
  void toggleSelectionMode() {
    selectionMode = !selectionMode;
    selectedNoteIds.clear(); // Reset selections when mode changes

    emit(List.from(state)); // Re-emit the state
    print('Selection mode: $selectionMode');
  }

  // Select or deselect a note
  void toggleNoteSelection(int noteId) {
    if (selectedNoteIds.contains(noteId)) {
      selectedNoteIds.remove(noteId);
    } else {
      selectedNoteIds.add(noteId);
    }
    emit(List.from(state)); // Re-emit the state
  }

  // Select all notes
  void selectAllNotes() {
    selectedNoteIds = state.map((note) => note.id).toSet();
    emit(List.from(state));
  }

  // Deselect all notes
  void deselectAllNotes() {
    selectedNoteIds.clear();
    emit(List.from(state));
  }

  // Delete selected notes
  Future<void> deleteSelectedNotes() async {
    for (int id in selectedNoteIds) {
      await notesRepo.deleteNoteById(id);
    }
    selectedNoteIds.clear();// Clear selected notes
    print("Deleted Notes: ${selectedNoteIds.toList()}");
    await loadNotes(); // Reload notes from the database
  }

  Future<void> deleteNote(NotesModal notesModal)async {
    await notesRepo.deleteNote(notesModal);
    final updatedNotes = state.where((note) => note.id != notesModal.id).toList();
    emit(updatedNotes);
  }
}