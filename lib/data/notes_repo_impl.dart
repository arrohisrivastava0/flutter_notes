import 'package:flutter_notes/domain/modal/notes_modal.dart';
import 'package:flutter_notes/domain/repository/notes_repo.dart';
import 'package:flutter_notes/services/database_service.dart';

class NotesRepoImpl implements NotesRepo{
  final DatabaseService _databaseService;

  NotesRepoImpl(this._databaseService);

  @override
  Future<void> addNote(NotesModal notesModal) async {
    await _databaseService.addNote(notesModal);
  }

  @override
  Future<void> deleteNote(NotesModal notesModal) async {
    await _databaseService.deleteNote(notesModal);
  }

  @override
  Future<void> deleteNoteById(int id) async {
    await _databaseService.delete('notes', 'id = ?', [id]);
  }

  @override
  Future<List<NotesModal>> getNotes() async{
    return await _databaseService.getNotes();
  }

  @override
  Future<void> updateNote(NotesModal notesModal) async{
    await _databaseService.updateNote(notesModal);
  }

}