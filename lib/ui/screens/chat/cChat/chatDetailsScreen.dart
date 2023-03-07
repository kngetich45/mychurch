 
import 'dart:io';

import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gugor_emoji/emoji_picker_flutter.dart';
import '../../../../features/chat/chatFirestoreDataSource.dart';
import '../../../../features/chat/chatRepository.dart';
import '../../../../features/chat/cubits/chatCubit.dart';
import '../../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../../utils/constants.dart';
import '../widget/OwnMessgaeCard.dart';
import '../widget/ReplyCard.dart'; 
 

class ChatDetailsScreen extends StatefulWidget {
 final String sname;
  final String rname;
  final String receiverUID;
 final String sprofileURL;
 final String receiverMobile;
  final String rprofileURL;
 final String receiverFID;
  final String senderUID;
 final String senderFID;
 final String isread;
 


  const ChatDetailsScreen({Key? key, required this.sname,required this.rname, required this.senderUID,required this.isread, required this.senderFID,  required this.receiverUID,required this.rprofileURL,  required this.sprofileURL, required this.receiverMobile, required this.receiverFID}) : super(key: key);

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState(); 
   static Route<dynamic> route(RouteSettings routeSettings) { 
     Map arguments = routeSettings.arguments as Map;
      return CupertinoPageRoute(
         builder: (_) => BlocProvider<ChatCubit>(
            create: (_) => ChatCubit(ChatRepository()),
            child: ChatDetailsScreen(
              rname: arguments['receiverName'],
              sname: arguments['senderName'],
              receiverUID: arguments['receiverUID'],
             receiverMobile: arguments['receiverMobile'],
             receiverFID: arguments['receiverFID'],
             sprofileURL: arguments['sprofileURL'],
             rprofileURL: arguments['rprofileURL'],
             senderUID: arguments['senderUID'],
             senderFID: arguments['senderFID'],
             isread: arguments['isread'],
            )));
  }
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  bool sendButton = false;
   

 Stream<QuerySnapshot>? chats;
 TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // connect();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  //  _getData();
  // _initGetData();

  _getChatMessage();
  _readChatUpdate();
  }

    _getChatMessage(){
       if(widget.receiverUID  == context.read<UserDetailsCubit>().getUserId()){
         ChatFirestoreDataSource().getPeerChats(context.read<UserDetailsCubit>().getUserId()+"_"+widget.senderUID).then((val)=>{
              setState(() {
                chats = val;
              })
            }); 
       }
       else{
         ChatFirestoreDataSource().getPeerChats(widget.receiverUID+"_"+context.read<UserDetailsCubit>().getUserId()).then((val)=>{
              setState(() {
                chats = val;
              })
            }); 

       }

           


  }
   _readChatUpdate(){
        if(widget.receiverUID  == context.read<UserDetailsCubit>().getUserId()){
           
            ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId())
            .updateReadResentChat(  
              context.read<UserDetailsCubit>().getUserId()+"_"+widget.senderUID,  
              widget.receiverFID, 
              ); 

        }else{
/* 
          ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId())
            .updateReadChatDetails(  
              widget.receiverUID+"_"+context.read<UserDetailsCubit>().getUserId(),  
              widget.receiverFID, 
              );  */

        } 

  }
 
   
  @override
  Widget build(BuildContext context) {


      sendPeerMessage() {
    if (_messageController.text.isNotEmpty) {
   
      String   rfid = "";
      String   ruid = "";
      String  rname = "";
      String?  rprofile = ""; 

       if(context.read<UserDetailsCubit>().getUserFirebaseId() == widget.receiverFID){
            
            rfid = widget.senderFID;
            ruid = widget.senderUID;
            rname = widget.sname;
            rprofile = widget.sprofileURL;
       }

     if(context.read<UserDetailsCubit>().getUserFirebaseId() == widget.senderFID){
            
            rfid = widget.receiverFID;
            ruid = widget.receiverUID;
            rname = widget.rname;
            rprofile = widget.rprofileURL;
       }
        
      
      Map<String, dynamic> chatMessageMap = {
        "messageContent": _messageController.text,
        "senderName": context.read<UserDetailsCubit>().getUserName(),
        "senderProfile": context.read<UserDetailsCubit>().getUserProfile().profileUrl,
        "senderFID": context.read<UserDetailsCubit>().getUserFirebaseId() ,
        "senderUID": context.read<UserDetailsCubit>().getUserId(),
        "receiverFID": rfid,
        "receiverName": rname,
        "receiverProfile": rprofile,
        "receiverUID": ruid,
        "timeStamp": DateTime.now().millisecondsSinceEpoch.toString(),
        "isread":'1',
      };
         if(widget.receiverUID  == context.read<UserDetailsCubit>().getUserId()){

      ChatFirestoreDataSource().sendChatsMessage(context.read<UserDetailsCubit>().getUserId()+"_"+widget.senderUID, chatMessageMap);
         }else{

          ChatFirestoreDataSource().sendChatsMessage(widget.receiverUID+"_"+context.read<UserDetailsCubit>().getUserId(), chatMessageMap);
 
         }

      setState(() {
        _messageController.clear();
      });
    }
  }

      

    return Stack(
      children: [
        Image.asset(
          "assets/images/backgroundChat.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              backgroundColor: primaryColor,
              leadingWidth: 70,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                    CircleAvatar( 
                     backgroundImage: NetworkImage(profileImage+ widget.rprofileURL),
                      radius: 20,
                      backgroundColor: Colors.blueGrey,
                    ),
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.rname,
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.receiverMobile,
                        //"last seen today at 12:05",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
                IconButton(icon: Icon(Icons.call), onPressed: () {}),
                PopupMenuButton<String>(
                  padding: EdgeInsets.all(0),
                  onSelected: (value) {
                    print(value);
                  },
                  itemBuilder: (BuildContext contesxt) {
                    return [
                      PopupMenuItem(
                        child: Text("View Contact"),
                        value: "View Contact",
                      ),
                      PopupMenuItem(
                        child: Text("Media, links, and docs"),
                        value: "Media, links, and docs",
                      ),
                      PopupMenuItem(
                        child: Text("Whatsapp Web"),
                        value: "Whatsapp Web",
                      ),
                      PopupMenuItem(
                        child: Text("Search"),
                        value: "Search",
                      ),
                      PopupMenuItem(
                        child: Text("Mute Notification"),
                        value: "Mute Notification",
                      ),
                      PopupMenuItem(
                        child: Text("Wallpaper"),
                        value: "Wallpaper",
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          body:  WillPopScope(
                      child: Column(
                        children: [


                           Expanded(

                             child: StreamBuilder(
                                      stream: chats,
                                      builder: (context, AsyncSnapshot snapshot) {
                                        return snapshot.hasData
                                            ? ListView.builder(
                                                itemCount: snapshot.data.docs.length,
                                                itemBuilder: (context, index) {
                                               
                                                      if (snapshot.data.docs[index]['senderFID'] == context.read<UserDetailsCubit>().getUserFirebaseId()) {
                                                        return OwnMessageCard(
                                                          message: snapshot.data.docs[index]['messageContent'],
                                                          time:snapshot.data.docs[index]['timeStamp'],
                                                          isread:widget.isread,
                                                        );
                                                      } else {
                                                        return ReplyCard(
                                                          message: snapshot.data.docs[index]['messageContent'],
                                                          time: snapshot.data.docs[index]['timeStamp'],
                                                        );
                                                      } 

                                                },
                                              )
                                            : Container( 
                                              child: Text(""), 
                                              );
                                      },
                                    ),

                           ),

 

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 70,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width - 60,
                                        child: Card(
                                          margin: EdgeInsets.only(
                                              left: 2, right: 2, bottom: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                          child: TextFormField(
                                            controller: _messageController,
                                            focusNode: focusNode,
                                            textAlignVertical: TextAlignVertical.center,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: 5,
                                            minLines: 1,
                                            onChanged: (value) {
                                              
                                              if (value.length > 0) {
                                                setState(() {
                                                  sendButton = true;
                                                });
                                              } else {
                                                setState(() {
                                                  sendButton = false;
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Type a message",
                                              hintStyle: TextStyle(color: Colors.grey),
                                              prefixIcon: IconButton(
                                                icon: Icon(
                                                  show
                                                      ? Icons.keyboard
                                                      : Icons.emoji_emotions_outlined,
                                                ),
                                                onPressed: () {
                                                 if (!show) {
                                                    focusNode.unfocus();
                                                    focusNode.canRequestFocus = false;
                                                  }  
                                                  setState(() {
                                                    show = !show;
                                                  });
                                                },
                                              ),
                                              suffixIcon: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.attach_file),
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                          backgroundColor:
                                                              Colors.transparent,
                                                          context: context,
                                                          builder: (builder) =>
                                                              bottomSheet());
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.camera_alt),
                                                    onPressed: () {
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (builder) =>
                                                      //             CameraApp()));
                                                    },
                                                  ),
                                                ],
                                              ),
                                              contentPadding: EdgeInsets.all(5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                          right: 2,
                                          left: 2,
                                        ),
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: primaryColor,
                                          child: IconButton(
                                            icon: Icon(
                                              sendButton ? Icons.send : Icons.mic,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              if (sendButton) {
                                            /*     _scrollController.animateTo(
                                                    _scrollController
                                                        .position.maxScrollExtent,
                                                    duration:
                                                        Duration(milliseconds: 300),
                                                    curve: Curves.easeOut); */
                                                sendPeerMessage();
                                                
                                                setState(() {
                                                  sendButton = false;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //show ? emojiSelect() : Container(),
 

                                 // emojiSelect()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      onWillPop: () {
                        if (show) {
                          setState(() {
                            show = false;
                          });
                        } else {
                          Navigator.pop(context);
                        }
                        return Future.value(false);
                      },
                    ),
                  //), 
                 ),    
          
      ],
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }


Widget emojiSelect() {

  return EmojiPicker(
    onEmojiSelected: (category, emoji) {
        // Do something when emoji is tapped
    },
    onBackspacePressed: () {
        // Backspace-Button tapped logic
        // Remove this line to also remove the button in the UI
    },
    config: Config(
        columns: 7,
        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
        verticalSpacing: 0,
        horizontalSpacing: 0,
        initCategory: Category.RECENT,
        bgColor: Color(0xFFF2F2F2),
        indicatorColor: Colors.blue,
        iconColor: Colors.grey,
        iconColorSelected: Colors.blue,
        progressIndicatorColor: Colors.blue,
        backspaceColor: Colors.blue,
        skinToneDialogBgColor: Colors.white,
        skinToneIndicatorColor: Colors.grey,
        enableSkinTones: true,
        showRecentsTab: true,
        recentsLimit: 28,
        noRecentsText: "No Recents",
        noRecentsStyle:
            const TextStyle(fontSize: 20, color: Colors.black26),
        tabIndicatorAnimDuration: kTabScrollDuration,    
        categoryIcons: const CategoryIcons(),
        buttonMode: ButtonMode.MATERIAL
    ),
);

}



 /*  Widget emojiSelect() {
   /*  return EmojiPicker(
         rows: 4,
        //columns: 7,
        onEmojiSelected: (category, emoji) {
          print(emoji);
          setState(() {
            _controller.text = _controller.text + emoji.emoji;
          });
        }); */
       return SizedBox(
                height: 250,
   child: EmojiPicker(
    onEmojiSelected: (category, emoji) {
        print(emoji);
          setState(() {
            _messageController.text = _messageController.text + emoji.emoji;
          });
    },
    onBackspacePressed: () {
        // Backspace-Button tapped logic
        // Remove this line to also remove the button in the UI
    },
     
     config: Config(
        columns: 7,
        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
        verticalSpacing: 0,
        horizontalSpacing: 0,
        gridPadding: EdgeInsets.zero,
        initCategory: Category.RECENT,
        bgColor: Color(0xFFF2F2F2),
        indicatorColor: Colors.blue,
        iconColor: Colors.grey,
        iconColorSelected: Colors.blue,
        backspaceColor: Colors.blue,
        skinToneDialogBgColor: Colors.white,
        skinToneIndicatorColor: Colors.grey,
        enableSkinTones: true,
        showRecentsTab: true,
        recentsLimit: 28,
        noRecents: const Text(
          'No Recents',
          style: TextStyle(fontSize: 20, color: Colors.black26),
          textAlign: TextAlign.center,
        ),
        tabIndicatorAnimDuration: kTabScrollDuration,    
        categoryIcons: const CategoryIcons(),
     )
   )
  );
  } */

/*   sendPeerMessages(String message, String firebaseId, String id, String name, String recepientImage) {

     Future.delayed(Duration.zero, () {
           context.read<ChatCubit>().sendChatMessageCub(
              senderId: context.read<UserDetailsCubit>().getUserId(),
              senderUid: context.read<UserDetailsCubit>().getUserFirebaseId(), 
              messageContent:message,
              sendTime:DateTime.now(),
              recipientUid: firebaseId,
              recipientid: id,
              messageType:'Text',  
              isRead:'1', 
              name:name, 
              recepientImage:recepientImage, 
              );

         //     _initGetData();



     });
 
  } */




 

}