
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/Notes.dart';
import '../NotesRepository.dart';

abstract class NewNotesState {}

class NewNotesInitial extends NewNotesState {}
class NewNotesFetchInProgress extends NewNotesState {}
class NewNotesSuccess extends NewNotesState { 
      
  final List<Notes> saveNotes;

  NewNotesSuccess(this.saveNotes);
}

class NewNotesFailure extends NewNotesState {
  final String errorMessage;

  NewNotesFailure(this.errorMessage);
}

class NewNotesLoading extends NewNotesState {}

class NewNotesCubit extends Cubit<NewNotesState> {
 // NotesCubit() : super(NotesInitial());
//List<Notes> notesList = [];
  
  final NotesRepository _notesRepository;
  NewNotesCubit(this._notesRepository) : super(NewNotesInitial());

  saveNotes({
  required String title,
  required Color color,
  required String content,
  required int date}
  ) async {
    
    emit(NewNotesFetchInProgress()); 
    _notesRepository.saveNotes(
      title: title,
      color: color,
      content: content,
      date: date
    ).then((val) {
      emit(NewNotesSuccess(val));
    }).catchError((e) {
      emit(NewNotesFailure(e.toString()));
    });
  }
   

     updateNote({
      required String? title,
      required Color? color,
      required String? content,
      required int? date,
      required int? id,
      }
  ) async {
    
    emit(NewNotesFetchInProgress()); 
    _notesRepository.updateNotes(
      title: title,
      color: color,
      content: content,
      date: date,
      id: id
    ).then((val) {
      emit(NewNotesSuccess(val));
    }).catchError((e) {
      emit(NewNotesFailure(e.toString()));
    });
  }
}
