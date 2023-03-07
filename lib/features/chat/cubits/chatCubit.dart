import 'package:flutter_bloc/flutter_bloc.dart';

import '../chatRepository.dart';
import '../models/ChatMessageModel.dart'; 
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatFetchInProgress extends ChatState {}

class ChatFetchSuccess extends ChatState {
  final List<ChatMessageModel> chatMessageList; 

  ChatFetchSuccess( 
      this.chatMessageList, 
   );
}

class ChatFetchFailure extends ChatState {
  final String errorMessage;

  ChatFetchFailure(this.errorMessage);
}

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;

  ChatCubit(this._chatRepository) : super(ChatInitial());

  final int limit = 15;
/* 
  getAllChatUsersCub({
  required String userId}
  ) async {
     emit(ChatFetchInProgress()); 
    _chatRepository.getAllChatUsersRepo(
      userId: userId, 
    ).then((val) {
      emit(ChatFetchSuccess(val));
    }).catchError((e) {
      emit(ChatFetchFailure(e.toString()));
    });
  } */
 
  sendChatMessageCub({
    required String senderId,required String isRead, required String senderUid, required String messageContent, required DateTime sendTime, required String recipientUid,required String recipientid, required String messageType, required String name, required String recepientImage}
    ) async {
      emit(ChatFetchInProgress()); 
      _chatRepository.sendChatMessageRepo(
        senderId: senderId,isRead: isRead, senderUid:senderUid, messageContent:messageContent, sendTime:sendTime, recipientUid:recipientUid, recipientid:recipientid, messageType:messageType, name:name, recepientImage:recepientImage
      ).then((val) {
        emit(ChatFetchSuccess(val));
      }).catchError((e) {
        emit(ChatFetchFailure(e.toString()));
      });
  } 

  getChatMessageCub( 
    ) async {
     emit(ChatFetchInProgress()); 
    _chatRepository.getchatMessageRepo(
    ).then((val) {
      
      print(val);
      emit(ChatFetchSuccess(val));
    }).catchError((e) {
      emit(ChatFetchFailure(e.toString()));
    });
  } 
 
 
}
