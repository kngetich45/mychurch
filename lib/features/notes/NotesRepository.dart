import 'dart:ui';

import '../../database/SQLiteDbProvider.dart';
import '../models/Notes.dart';
import 'NotesException.dart';
import 'NotesLocalDataSource.dart';

class NotesRepository {
  static final NotesRepository _notesRepository = NotesRepository._internal();
  late NotesLocalDataSource _notesLocalDataSource;

  factory NotesRepository() {
    _notesRepository._notesLocalDataSource = NotesLocalDataSource();

    return _notesRepository;
  }

  NotesRepository._internal();
 
  Future<List<Notes>> getNotes() async {
    
    try {
      List<Notes> notesList = []; 
        notesList = await SQLiteDbProvider.db.getAllNotes();
      print(notesList); 
      return notesList;
    } catch (e) {
      throw NotesException(errorMessageCode: e.toString());
    }
  }

  Future saveNotes({
  required String title,
  required Color color,
  required String content,
  required int date}
      
      ) async {
    try {
      await _notesLocalDataSource.saveNote(
      title: title,
      color: color,
      content: content,
      date: date);
    } catch (e) {
      throw NotesException(errorMessageCode: e.toString());
    }
  }

  Future updateNotes({
  required String? title,
  required Color? color,
  required String? content,
  required int? date,
  required int? id}
      
      ) async {
    try {
      await _notesLocalDataSource.updateNotes(
      title: title,
      color: color,
      content: content,
      date: date,
       id: id);
    } catch (e) {
      throw NotesException(errorMessageCode: e.toString());
    }
  }

}
