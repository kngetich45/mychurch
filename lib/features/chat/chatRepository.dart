 
import 'chatException.dart';
import 'chatRemoteDataSource.dart';
import 'models/ChatMessageModel.dart';
import 'models/ChatUsersModel.dart';

class ChatRepository {
  static final ChatRepository _chatRepository =
      ChatRepository._internal();

  late ChatRemoteDataSource _chatRemoteDataSource;

  factory ChatRepository() {
    _chatRepository._chatRemoteDataSource =
        ChatRemoteDataSource();
    return _chatRepository;
  }

  ChatRepository._internal();

  Future<Map<String, dynamic>> getChat(
      {required String userId,
      required String offset,
      required String limit}) async {
    final result = await _chatRemoteDataSource.getChat(
        userId: userId, limit: limit, offset: offset);

    return {
      "total": result['total'],
      "Chat":
          (result['data'] as List).map((e) => ChatUsersModel.fromJson(e)).toList(),
    };
  }
 

    Future sendChatMessageRepo({required String senderId,required String isRead, required String senderUid, required String messageContent, required DateTime sendTime, required String recipientUid,required String recipientid, required String messageType, required String name, required String recepientImage}
      
      ) async {
    try {
      await _chatRemoteDataSource.sendChatMessage(
         senderId: senderId,isRead: isRead, senderUid:senderUid, messageContent:messageContent, sendTime:sendTime, recipientUid:recipientUid, recipientid:recipientid, messageType:messageType, name:name, recepientImage:recepientImage
          );
    } catch (e) {
      throw ChatException(errorMessageCode: e.toString());
    }
  }
  

   Future<List<ChatUsersModel>> getAllChatUsersRepo({ required String userId }) async {
    try { 
      List<ChatUsersModel> usersList = [];
      List result = await _chatRemoteDataSource.fetchusersChatList(userId: userId);
     
      usersList = result
          .map((hymnsCat) => ChatUsersModel.fromJson(Map.from(hymnsCat)))
          .toList();
         
      return usersList;
    } catch (e) {
      throw ChatException(errorMessageCode: e.toString());
    }
  }

Future<List<ChatMessageModel>> getchatMessageRepo() async {
   
    try { 
      List<ChatMessageModel> chatList = [];

      List result = await _chatRemoteDataSource.fetchChatMessageList();
       
      chatList = result
          .map((chatCat) => ChatMessageModel.fromJson(Map.from(chatCat)))
          .toList();
         
      return chatList;
    } catch (e) {
      throw ChatException(errorMessageCode: e.toString());
    }
  }

 
 
}
