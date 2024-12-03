import 'dart:async';
import 'dart:io';

import 'package:flutter_notes/domain/modal/notes_modal.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


class DatabaseService{
  final String tableNotes='notes';
  final String id='id';
  final String title='title';
  final String body='body';
  static final DatabaseService instance=DatabaseService._constructor();
  DatabaseService._constructor(){
    if(!Platform.isAndroid && !Platform.isIOS){
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }
  static Database ? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async{
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    String path= join(appDocumentsDir.path, 'master_db.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate
    );
  }

  Future<void> _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE $tableNotes(
        $id INTEGER PRIMARY KEY AUTOINCREMENT,
        $title TEXT NOT NULL,
        $body TEXT
      )
    ''');
  }

  Future<NotesModal> addNote(NotesModal note) async{
    final db=await database;
    note.id = await db.insert(tableNotes, note.toMap());
    return note;
  }

  Future<int> updateNote(NotesModal note) async{
    final db=await database;
    return await db.update(tableNotes, note.toMap(),
        where: '$id = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNote(NotesModal note) async{
    final db=await database;
    return await db.delete(tableNotes,
        where: '$id = ?', whereArgs: [note.id]);
  }

  Future<List<NotesModal>> getNotes() async{
    final db=await database;
    final maps=await db.query(tableNotes);
    return maps.map((map)=> NotesModal.fromMap(map)).toList();
  }

  Future close() async => _database!.close();
}