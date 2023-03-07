
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../CommentsRepository.dart';
import '../models/CommentsModel.dart'; 

abstract class CommentsState {}

class CommentsInitial extends CommentsState {}
class CommentsFetchInProgress extends CommentsState {}
class CommentsSuccess extends CommentsState { 
 final List<CommentsModel> commentsList;
  CommentsSuccess(this.commentsList);  
}

class CommentsFailure extends CommentsState {
  final String errorMessage;

  CommentsFailure(this.errorMessage);
}

class CommentsLoading extends CommentsState {}

class CommentsCubit extends Cubit<CommentsState> {
  final CommentsRepository _commentsRepository;
  CommentsCubit(this._commentsRepository) : super(CommentsInitial());
 
   void getMakeCommentsC({required String media, required String userId, String? userEmail, required String content}) async {
    emit(CommentsFetchInProgress());
    _commentsRepository
        .getMakeCommentsRepository(media: media, userId: userId,userEmail: userEmail, content: content)
        .then(
          (val) => emit(CommentsSuccess(val)),
        )
        .catchError((e) {
      emit(CommentsFailure(e.toString()));
    });
  }

 void getCommentsC({required String mediaId, required String userId, String? userEmail, required String comentsId}) async {
    emit(CommentsFetchInProgress());
    _commentsRepository
        .getCommentsRepository(mediaId: mediaId, userId: userId,userEmail: userEmail, comentsId: comentsId)
        .then(
          (val) => emit(CommentsSuccess(val)),
        )
        .catchError((e) {
      emit(CommentsFailure(e.toString()));
    });
  }
}
