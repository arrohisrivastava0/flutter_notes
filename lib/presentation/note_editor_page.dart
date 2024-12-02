import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/domain/modal/notes_modal.dart';
import 'package:flutter_notes/presentation/notes_cubit.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteEditorPage extends StatefulWidget {
  final NotesModal notesModal;
  final bool isNew;

  NoteEditorPage({
    super.key,
    required this.notesModal,
    required this.isNew
  });

  @override
  State<NoteEditorPage> createState()=>_NoteEditorPageState();
}


class _NoteEditorPageState extends State<NoteEditorPage>{
  late NotesCubit notesCubit;
  QuillController _controller = QuillController.basic();
  late String title=widget.notesModal.title;

  @override
  void initState(){
    super.initState();
    loadExistingNote();
  }

  void loadExistingNote(){
    title=widget.notesModal.title;
    final doc=Document()..insert(0, widget.notesModal.body);
    setState(() {
      _controller=QuillController(document: doc, selection: TextSelection.collapsed(offset: 0));
    });
  }

  void saveNewNote(int id){
    String body=_controller.document.toPlainText();
    notesCubit.addNote(title, body);
  }

  void saveUpdatedNote(){
    String body=_controller.document.toPlainText();
    notesCubit.updateNote(title, body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
    );
  }
}
