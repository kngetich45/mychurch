
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/Notes.dart';
import '../NotesRepository.dart';

abstract class NotesState {}

class NotesInitial extends NotesState {}
class NotesFetchInProgress extends NotesState {}
class NotesSuccess extends NotesState { 
 final List<Notes> notesList;
  NotesSuccess(this.notesList);  
}

class NotesFailure extends NotesState {
  final String errorMessage;

  NotesFailure(this.errorMessage);
}

class NotesLoading extends NotesState {}

class NotesCubit extends Cubit<NotesState> { 
  final NotesRepository _notesRepository;
  NotesCubit(this._notesRepository) : super(NotesInitial());

 void getNotes() async {
    
    emit(NotesFetchInProgress());
    _notesRepository.getNotes().then((val) {
      emit(NotesSuccess(val));
    }).catchError((e) {
      emit(NotesFailure(e.toString()));
    });
  }

   void getNotesByID(int itemsID) async {
    
    emit(NotesFetchInProgress());
    _notesRepository.getNotes().then((val) {
      emit(NotesSuccess(val));
    }).catchError((e) {
      emit(NotesFailure(e.toString()));
    });
  }

 
}
