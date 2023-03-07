import 'dart:convert';
import 'dart:io';
  
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:http/http.dart' as http;

import '../../utils/apiBodyParameterLabels.dart';
import '../../utils/apiUtils.dart';
import '../../utils/constants.dart';
import '../../utils/errorMessageKeys.dart';
import 'chatException.dart'; 

class ChatRemoteDataSource {

   final FirebaseFirestore _db = FirebaseFirestore.instance;
   
   

  Future<dynamic> getChat(
      {required String userId,
      required String limit,
      required String offset}) async {
    try {
      //body of post request
      final body = {
        accessValueKey: accessValue,
        userIdKey: userId,
        limitKey: limit,
        offsetKey: offset,
      };

      if (limit.isEmpty) {
        body.remove(limitKey);
      }

      if (offset.isEmpty) {
        body.remove(offsetKey);
      }

      final response = await http.post(Uri.parse(getCategoryUrl),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);

      if (responseJson['error']) {
        throw ChatException(
          errorMessageCode: responseJson['message'],
        );
      }

      return responseJson;
    } on SocketException catch (_) {
      throw ChatException(errorMessageCode: noInternetCode);
    } on ChatException catch (e) {
      throw ChatException(errorMessageCode: e.toString());
    } catch (e) {
      throw ChatException(errorMessageCode: defaultErrorMessageCode);
    }
  }
  
    Future<dynamic> sendChatMessage(
      {required String senderId,required String isRead, required String senderUid, required String messageContent, required DateTime sendTime, required String recipientUid,required String recipientid, required String messageType, required String name, required String recepientImage}) async {
        try {
          //body of post request
          final body = {
            "senderId": senderId,
            "senderUid":senderUid,
            "messageContent":messageContent,
            "sendTime":sendTime,
             "recipientUid":recipientUid,
             "recipientid":recipientid,
             "messageType":messageType,
             "isRead": isRead,
             "name":name, 
             "recepientImage":recepientImage
          };  
          CollectionReference collectionReference = _db.collection(chatMessage);
          collectionReference.add(body)
              .then((value) => print("Message Submited"))
              .catchError((error) => print("Message couldn't be submited.")); 
   
         return 1; 
    } on SocketException catch (_) {
      throw ChatException(errorMessageCode: noInternetCode);
    } on ChatException catch (e) {
      throw ChatException(errorMessageCode: e.toString());
    } catch (e) {
      throw ChatException(errorMessageCode: defaultErrorMessageCode);
    }
  }   
 

Future<List> fetchusersChatList({required String userId}) async {
    try {
      Map<String, String> body = {
        accessValueKey: accessValue,
        userIdKey: userId
      };
 
      final response = await http.post(Uri.parse(getChatUsersList),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw ChatException(errorMessageCode: responseJson['message']); //error
      } 
      
      return responseJson['data'];
    } on SocketException catch (_) {
      throw ChatException(errorMessageCode: noInternetCode);
    } on ChatException catch (e) {
      throw ChatException(errorMessageCode: e.toString());
    } catch (e) {
      throw ChatException(errorMessageCode: defaultErrorMessageCode);
    }
  }
  
  Future<List> fetchChatMessageList() async {
          try {
            Query collectionRef = FirebaseFirestore.instance.collection(chatMessage).orderBy('sendTime', descending: true);

           //  CollectionReference _products = FirebaseFirestore.instance.collection(chatMessage);
              QuerySnapshot querySnapshot = await collectionRef.get();
                        final temp = querySnapshot.docs.map((doc) => doc.data()).toList();
                         
                        return temp; 
          
          } on SocketException catch (_) {
            throw ChatException(errorMessageCode: noInternetCode);
          } on ChatException catch (e) {
            throw ChatException(errorMessageCode: e.toString());
          } catch (e) {
            throw ChatException(errorMessageCode: defaultErrorMessageCode);
          }
      }  

   


getUserGroups() async {
  
}




}
