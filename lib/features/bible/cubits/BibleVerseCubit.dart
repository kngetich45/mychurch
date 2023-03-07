
import 'package:flutter_bloc/flutter_bloc.dart';
 
import '../BibleRepository.dart';
import '../models/BibleVersionsModel.dart';

abstract class BibleVerseState {}

class BibleVerseInitial extends BibleVerseState {}
class BibleVerseFetchInProgress extends BibleVerseState {}
class BibleVerseSuccess extends BibleVerseState { 
 final List<BibleVersionsModel> bibleVerseList; 
  BibleVerseSuccess(this.bibleVerseList);  
}

class BibleVerseFailure extends BibleVerseState {
  final String errorMessage;

  BibleVerseFailure(this.errorMessage);
}

class BibleVerseLoading extends BibleVerseState {}

class BibleVerseCubit extends Cubit<BibleVerseState> { 
  final BibleRepository _bibleRepository;
  BibleVerseCubit(this._bibleRepository) : super(BibleVerseInitial());

 void getBibleVerse({required String userId}) async {
    
    emit(BibleVerseFetchInProgress());
    _bibleRepository.getBibleVerse(userId: userId).then((val) {
      emit(BibleVerseSuccess(val));
    }).catchError((e) {
      emit(BibleVerseFailure(e.toString()));
    });
  }

   void getdownloadFileItems({required String userId, required String bibleSource, required var filePath}) async {
    
    emit(BibleVerseFetchInProgress());
    _bibleRepository.getBibledownloadFile(userId: userId,bibleSource: bibleSource,filePath: filePath).then((val) {
      emit(BibleVerseSuccess(val));
    }).catchError((e) {
      emit(BibleVerseFailure(e.toString()));
    });
  }
 

 
}
