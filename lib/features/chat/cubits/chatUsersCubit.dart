import 'package:flutter_bloc/flutter_bloc.dart';

import '../chatRepository.dart'; 
import '../models/ChatUsersModel.dart'; 

abstract class ChatUsersState {}

class ChatUsersInitial extends ChatUsersState {}

class ChatUsersFetchInProgress extends ChatUsersState {}

class ChatUsersFetchSuccess extends ChatUsersState {
  final List<ChatUsersModel> chatUsersModelList; 

  ChatUsersFetchSuccess(this.chatUsersModelList);
}

class ChatUsersFetchFailure extends ChatUsersState {
  final String errorMessage;

  ChatUsersFetchFailure(this.errorMessage);
}

class ChatUsersCubit extends Cubit<ChatUsersState> {
  final ChatRepository _chatRepository;

  ChatUsersCubit(this._chatRepository) : super(ChatUsersInitial());
   
 getAllChatUsersCub({
  required String userId}
  ) async {
     emit(ChatUsersFetchInProgress()); 
    _chatRepository.getAllChatUsersRepo(
      userId: userId, 
    ).then((val) {
      emit(ChatUsersFetchSuccess(val));
    }).catchError((e) {
      emit(ChatUsersFetchFailure(e.toString()));
    });
  } 
}
