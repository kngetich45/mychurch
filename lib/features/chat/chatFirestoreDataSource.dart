 
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirestoreDataSource {

  final String? uid;
  ChatFirestoreDataSource({this.uid});

 final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
 final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");
 final CollectionReference chatsCollection = FirebaseFirestore.instance.collection("ChatMessage");


Future updateUserData(String fullName, String email, String userId, String profilePic) async {
  return await userCollection.doc(uid).set({
    "fullName": fullName,
    "email": email,
    "userId": userId,
    "groups": [],
    "profilePic": profilePic,
    "uid": uid,
  });
}

Future getUserData(String userId) async {
   QuerySnapshot snapshot = 
   await userCollection.where("userId", isEqualTo: userId).get();
    
   return snapshot;
}

getUserGroups() async {

  return userCollection.doc(uid).snapshots(); 
}
   

 getResentGroups(String userName) {
    //  final Stream<QuerySnapshot> _usersStream = groupCollection.where("members", arrayContains: "${uid}_$userName").snapshots();
     final Stream<QuerySnapshot> _usersStream = groupCollection.where("members", arrayContains: "${uid}_$userName").snapshots();
     return _usersStream; 
}

//create a group

Future createGroup(String userName, String fid, String groupName, String userId) async {
 
 DocumentReference groupDocumentReference = await groupCollection.add({
  "groupName": groupName,
  "recentSenderName": userName,
  "recentSenderFID":fid,
  "groupIcon": "",
  "admin": "${fid}_$userName",
  "members": [],
  //"hasReadMessage": [],
  "groupId": "",
  "recentMessage": "", 
   "recentSenderUserId": userId,
   "isread": '1',
   "isNotRead":'0',
   "recentMessageTime":DateTime.now().millisecondsSinceEpoch.toString(),
  });
   
   //update members
  await groupDocumentReference.update({
    "members": FieldValue.arrayUnion(["${uid}_$userName"]),
    "groupId": groupDocumentReference.id,
    //"hasReadMessage": FieldValue.arrayUnion(["${uid}_0"]),
  });

  //update usercollection -goupname

  DocumentReference userDocumentRference = userCollection.doc(uid);
  return await userDocumentRference.update({
    "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
  }); 
 } 

 getGroupChats(String groupId) async {
  return groupCollection
       .doc(groupId)
       .collection("messages")
       .orderBy("time")
       .snapshots();
 }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  searchByName(String groupName){
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }
   
   getAllGroup(){
     
    return groupCollection.where("groupName", isNotEqualTo: "").get();
  }

   Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
        print("${uid}_$userName");
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
      /* await groupDocumentReference.update({
        "hasReadMessage": FieldValue.arrayRemove(["${uid}_0"])
      }); */
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
     /*  await groupDocumentReference.update({
        "hasReadMessage": FieldValue.arrayUnion(["${uid}_0"])
      }); */
    }
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
     groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentSenderName": chatMessageData['senderName'],
       "recentSenderUserId": chatMessageData['senderUID'],
      "recentSenderFID": chatMessageData['senderFID'],
      "recentMessageTime": chatMessageData['time'].toString(),
       "isread":'1',
       "isNotRead": FieldValue.increment(1),
    });  
           
    
 /*   DocumentReference groupCollections = groupCollection.doc(groupId);
     DocumentSnapshot documentSnapshot = await groupCollections.get();
    List<dynamic> hasReadMessage = await documentSnapshot['hasReadMessage'];
     
    final myUid = (hasReadMessage).map((item) => item as String).toList();
 
      List<String> filter = [];
      filter.addAll(myUid);

      filter.retainWhere((countryone){
          return countryone.contains("$uid"); 
      }); 
      String currentvalue = filter[0].split('_').last; 
      var changeValue = int.parse(currentvalue); 
      var addedValue = changeValue+1; 
        print(changeValue);
        print(addedValue);
    

      await groupCollections.update({
            "hasReadMessage": FieldValue.arrayRemove(["${uid}_$changeValue"])
          });

      await groupCollections.update({
            "hasReadMessage": FieldValue.arrayUnion(["${uid}_$addedValue"]),
        
      }); */





/* 
      List<String> numbers = ["0","1", "2", "3","4", "5", "6","7", "8", "9","10", "11"];

         for (int i = 0; i < numbers.length; i++) { 
      
               if (filter  hasReadMessage.contains("${uid}_${numbers[i]}")) {
               //if (hasReadMessage.contains("${uid}_${numbers[i]}")) {
                  print("addedValue");
               
                    var test = hasReadMessage[0]; 
                    String  currentvalue = test.split('_').last; 
                    var changeValue = int.parse(currentvalue); 
                    var addedValue = changeValue+1; 
                     print(changeValue);
                    print(addedValue);
                  

                    await groupCollections.update({
                          "hasReadMessage": FieldValue.arrayRemove(["${uid}_$changeValue"])
                        });

                    await groupCollections.update({
                         "hasReadMessage": FieldValue.arrayUnion(["${uid}_$addedValue"]),
                      
                    });
                  } else {
                  
                    } 
        }   */ 

  }

 updateReadResentGroupChat(String groupId,String senderUserId) async{  
     groupCollection.doc(groupId).update({
            "isNotRead": 0,
            "isread": "2", 
          });

  }

//___________________________________________________________________________________________________________________________________________________________

  //chats 


   getResentChats(String userName) { 
      final Stream<QuerySnapshot> _chatsStream = chatsCollection.where("users", arrayContains: "$uid").snapshots(includeMetadataChanges: true); 
      return _chatsStream; 
   }

  
  getPeerChats(String peerId) async {
     return chatsCollection
       .doc(peerId)
       .collection("chats")
       .orderBy("timeStamp")
       .snapshots();
 }

 //create a chat

  

  Future createPeerChat(String userName, String firebaseId, String peerName, String userId, String profileurl,String rName,String rFID,String rProfile,String rUid,String rmobile) async {

     return await chatsCollection.doc(peerName).set({
             // "peerId": "",  
            "users": FieldValue.arrayUnion(["$uid","$rFID"]), 
             // "users": FieldValue.arrayUnion(["$usendDetails","$ureceiveDetails"]), 
              "senderName": userName,
              "senderProfile": profileurl,
              "senderFID": firebaseId,
              "senderUID": userId,
              "receiverFID": rFID,
              "receiverName": rName,
              "receiverProfile": rProfile,
              "receiverUID": rUid,
              "receiverMobile": rmobile,
              "recentChat":"",
              "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(), 
              "peerName":peerName,
              "isread":'1',
              "isNotRead":'0',
              
      }); 
}  

/*    Future createPeerChat(String userName, String id, String peerName, String userId) async {

 
    QuerySnapshot querySnapshot = await chatsCollection.where("peerName", isEqualTo: peerName).get();
    final _docData = querySnapshot.docs.map((doc) => doc.data()).toList();
     
     if(_docData.isEmpty)
     {
          DocumentReference peerDocumentReference = await chatsCollection.add({
            "peerId": "",  
            "users": [], 
            "recentChat": "",
            "recentChatSender": "",
            "recentSenderFID": "",
            "recentSenderUID": userId,
            "recentChatTime": DateTime.now().millisecondsSinceEpoch.toString(), 
            "peerName":peerName
            });
            
            //update members
            await peerDocumentReference.update({
              "users": FieldValue.arrayUnion(["${uid}_$userName"]),
              "peerId": peerDocumentReference.id
            });
     }else{
      print("Peer account Exist");
     } 
          //update usercollection -goupname

         /*  DocumentReference userDocumentRference = userCollection.doc(uid);
          return await userDocumentRference.update({
            "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
          });  */
 }    */
 

 //send Chats

   sendChatsMessage(String peerName, Map<String, dynamic> chatMessageData) async { 
          chatsCollection.doc(peerName).collection("chats").add(chatMessageData);
          chatsCollection.doc(peerName).update({
            "recentChat": chatMessageData['messageContent'],
            "senderName": chatMessageData['senderName'],
            "senderProfile": chatMessageData['senderProfile'],
            "senderFID": chatMessageData['senderFID'],
            "senderUID": chatMessageData['senderUID'],
            "receiverFID": chatMessageData['receiverFID'],
            "receiverName": chatMessageData['receiverName'],
            "receiverProfile": chatMessageData['receiverProfile'],
            "receiverUID": chatMessageData['receiverUID'],
            "timeStamp": chatMessageData['timeStamp'],
            "isread": '1',
            "isNotRead": FieldValue.increment(1),
           // "recentChatTime": chatMessageData['timeStamp'].toString(),
          });
 
  }
//update resent chat
  updateReadResentChat(String peerName,String receiverFID) async{  
     chatsCollection.doc(peerName).update({
            "isNotRead": 0,
            "isread": "2", 
          });

  }

  //update isRead on Details
/* 
  updateReadChatDetails(String peerName,String receiverFID) async{ 
    print(peerName); 
    chatsCollection.doc(peerName).collection("chats").doc().update({
            "isread": "2", 
          });
    

  } */
 

}
