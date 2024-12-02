import 'package:flutter_notes/domain/modal/notes_modal.dart';

abstract class NotesRepo{
  Future<void> addNote(NotesModal notesModal);
  Future<void> updateNote(NotesModal notesModal);
  Future<void> deleteNote(NotesModal notesModal);
  Future<List<NotesModal>> getNotes();
}
