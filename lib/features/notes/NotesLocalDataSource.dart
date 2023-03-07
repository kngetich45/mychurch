
import 'dart:ui';

import '../../database/SQLiteDbProvider.dart';
import '../models/Notes.dart';

class NotesLocalDataSource {
    List<Notes> notesList = [];
    
  getNotes() async {
    notesList = await SQLiteDbProvider.db.getAllNotes();
     print("Test results");
     
    //notifyListeners();
  }

 /*  saveNote(Notes notes) async {
    await SQLiteDbProvider.db.saveNote(notes);
    getNotes();
  } */
  saveNote({String? title, Color? color,String? content,int? date}) async {
   Notes myNote = new Notes(
                          title: title,
                          color: color,
                          content: content,
                          date: date);  
    await SQLiteDbProvider.db.saveNote(myNote);
    getNotes();
  }

  updateNotes({int? id, String? title, Color? color,String? content,int? date}) async {
   Notes myNote = new Notes(
                          title: title,
                          color: color,
                          content: content,
                          date: date,
                          id: id);  
    await SQLiteDbProvider.db.saveNote(myNote);
    getNotes();
  }

  deleteNote(Notes notes) async {
    await SQLiteDbProvider.db.deleteNote(notes.id);
    getNotes();
  }

  searchNotes(String term) {
    List<Notes> _items = notesList.where((notes) {
      return notes.title!.toLowerCase().contains(term.toLowerCase()) ||
          notes.content!.toLowerCase().contains(term.toLowerCase());
    }).toList();
    notesList = _items;
   // notifyListeners();
  }
}