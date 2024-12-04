class NotesModal{
  int id;
  String title;
  String body;

  NotesModal({required this.id, required this.title, required this.body});

  factory NotesModal.fromMap(Map<String, dynamic> map){
    return NotesModal(
        id: map['id'],
        title: map['title'],
        body: map['body']?? '',
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'title':title,
      'body':body,
    };
  }
}