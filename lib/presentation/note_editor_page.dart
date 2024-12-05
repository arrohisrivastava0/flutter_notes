import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late QuillController _controller;
  late String title;

  @override
  void initState(){
    super.initState();
    title = widget.notesModal.title;
    _controller = QuillController(
      document: Document()..insert(0, widget.notesModal.body),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  void loadExistingNote(){
    title=widget.notesModal.title;
    final doc = Document();
    if (widget.notesModal.body.isNotEmpty) {
      doc.insert(0, widget.notesModal.body);
    }
    setState(() {
      _controller=QuillController(document: doc, selection: TextSelection.collapsed(offset: 0));
    });
  }

  void _saveAlert(BuildContext context){
    showDialog(context: context, builder: (context) =>
    AlertDialog(
      title: const Text('Save Note'),
      content: const Text('Are you sure you dont want to save note'),
      actions:[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _saveNote();
            Navigator.pop(context);
          },
          child: const Text('Save'),

        )
      ],
    ));
  }

  void _saveNote() async{
    final body = _controller.document.toPlainText().trim();
    print('Updating note in save note func cubit: $body');
    final notesCubit = context.read<NotesCubit>();
    if (widget.isNew) {
      await notesCubit.addNote(title, body);
    } else {
      await notesCubit.updateNote(widget.notesModal.id, title, body);
    }
    notesCubit.loadNotes();
    Navigator.pop(context); // Navigate back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _saveAlert(context);
            // _saveNote();
            // Navigator.pop(context); // Default back behavior
            // Add additional logic here
          },
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed:() {
               _saveNote();
              // Navigator.pop(context);
            }
          ),
        ],
      ),
      body: Column(
        children: [
          QuillToolbar.simple(controller: _controller),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: QuillEditor.basic(
                controller: _controller,
                // Set to true if the editor should be read-only
              ),
            ),
          ),
        ],
      ),

    );
  }
}
