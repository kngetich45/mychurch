

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String messageContent,messageType,recipientid,recipientUid,senderId,senderUid,name,recepientImage;
  final Timestamp sendTime;
  final String isRead; 
  ChatMessageModel({ 
        // required this.docId,
        required this.messageContent,
        required this.messageType,
        required this.recipientUid,
        required this.isRead, 
        required this.recipientid,
        required this.sendTime,
        required this.senderId,
        required this.senderUid,
         required this.name,
        required this.recepientImage
    });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    //print(json);
   // int isRead = int.parse(json['isRead'].toString()); 
    return ChatMessageModel(
        
        messageContent: json['messageContent'],
        isRead: json['isRead'],
        messageType: json['messageType'],
        recipientUid: json['recipientUid'],
         sendTime: json['sendTime'],
        recipientid: json['recipientid'], 
         senderUid: json['senderUid'], 
         recepientImage: json['recepientImage'],
         name: json['name'],
        senderId: json['senderId']);
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> json) {
    return ChatMessageModel(
        isRead: json['isRead'],
         //docId: json['id'],
        messageContent: json['messageContent'],
        messageType: json['messageType'],
        recipientUid: json['recipientUid'],
        sendTime: json['sendTime'],
        recipientid: json['recipientid'], 
        senderUid: json['senderUid'], 
        recepientImage: json['recepientImage'], 
        name: json['name'],
        senderId: json['senderId']);
  }

  Map<String, dynamic> toMap() =>
      {"isRead": isRead, "messageContent": messageContent, "messageType": messageType,"recipientUid": recipientUid,"sendTime": sendTime, "recipientid": recipientid, "senderId": senderId, "senderUid": senderUid,"name": name, "recepientImage": recepientImage};

 Map<String, Object?> toJson() {
    return {
      'isRead': isRead,
      'messageContent': messageContent,
      'recipientUid': recipientUid,
      'sendTime': sendTime,
      'recipientid': recipientid,
      'senderUid': senderUid,
      'senderId': senderId,
      'recepientImage': recepientImage,
      'name': name,
    };
  }
       
}
  