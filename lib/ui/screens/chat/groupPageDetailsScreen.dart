import 'package:bevicschurch/features/chat/chatFirestoreDataSource.dart';
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes.dart';
import '../../../features/chat/chatRepository.dart';
import '../../../features/chat/cubits/chatCubit.dart';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import 'widget/groupOwnMessgaeCard.dart';
import 'widget/groupReplyCard.dart'; 

class GroupPageDetailsScreen extends StatefulWidget { 
  final String senderName;
  final String groupId;
  final String groupName;
  final String senderUserId;
  final String isread;
  const GroupPageDetailsScreen({Key? key,
                   required this.senderName,
                   required this.groupId,
                   required this.groupName,
                   required this.senderUserId,
                   required this.isread
                   }) : super(key: key);

  @override
  State<GroupPageDetailsScreen> createState() => _GroupPageDetailsScreenState();
    static Route<dynamic> route(RouteSettings routeSettings) { 
     Map arguments = routeSettings.arguments as Map;
      return CupertinoPageRoute(
         builder: (_) => BlocProvider<ChatCubit>(
            create: (_) => ChatCubit(ChatRepository()),
            child: GroupPageDetailsScreen(
              senderName: arguments['senderName'],
              groupId: arguments['groupId'],
             groupName: arguments['groupName'],
             senderUserId: arguments['senderUID'], 
              isread: arguments['isread'], 
            )));
  }
}

class _GroupPageDetailsScreenState extends State<GroupPageDetailsScreen> {
   Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
   ScrollController _scrollController = ScrollController();
 bool show = false;
  String admin = "";
   FocusNode focusNode = FocusNode();
  bool sendButton = false;
  @override
  void initState(){
      focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
    _getChatAdmin();
    _readGroupChatUpdate();
    super.initState();
  }

  _getChatAdmin(){
    ChatFirestoreDataSource().getGroupChats(widget.groupId).then((val)=>{
      setState(() {
        chats = val;
      })
    });

    ChatFirestoreDataSource().getGroupAdmin(widget.groupId).then((value) => {
      setState((() => {
        admin = value
      })) 
    });

  }
    _readGroupChatUpdate(){
        if(widget.senderUserId  != context.read<UserDetailsCubit>().getUserId()){
           
            ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId())
            .updateReadResentGroupChat(  
              widget.groupId,  
              widget.senderUserId, 
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
                   /*  CircleAvatar( 
                     backgroundImage: NetworkImage(profileImage+widget.profileURL),
                      radius: 20,
                      backgroundColor: Colors.blueGrey,
                    ), */
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
                        widget.groupName,
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tab here to view the details',
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
                     if(value == "View Details"){
                               Navigator.of(context).pushNamed(Routes.groupInfo, 
                                arguments: {
                                            "senderName": widget.senderName,
                                            "groupId": widget.groupId,
                                            "groupName": widget.groupName,
                                            "senderUserId": widget.senderUserId,
                                            "adminName": admin,
                                });
            

                     } 
                  },
                  itemBuilder: (BuildContext contesxt) {
                    return [
                      PopupMenuItem(
                        child: Text("View Details"),
                        value: "View Details",
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
       body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
         child: WillPopScope(
                        child: Column( 
                            children: <Widget>[
                          // chat messages here
                          
                              chatMessages(),
                              
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
                                                            controller: messageController,
                                                            focusNode: focusNode,
                                                            textAlignVertical: TextAlignVertical.top,
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
                                                                  if (_scrollController.hasClients) {
                                                                _scrollController.animateTo(
                                                                    _scrollController
                                                                        .position.maxScrollExtent,
                                                                    duration:
                                                                        Duration(milliseconds: 300),
                                                                    curve: Curves.easeOut);  
                                                                  }
                                                                sendMessage();
                                                                
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




                          /*   Container(
                            alignment: Alignment.bottomCenter,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey[700],
                              child: Row(children: [
                                Expanded(
                                    child: TextFormField(
                                  controller: messageController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: "Send a message...",
                                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                                    border: InputBorder.none,
                                  ),
                                )),
                                const SizedBox(
                                  width: 12,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    sendMessage();
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Center(
                                        child: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    )),
                                  ),
                                )
                              ]),
                            ),
                          ) */
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
       ),
      )
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



  chatMessages() {
    return Expanded(
      
      child: StreamBuilder(
        stream: chats,
        
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
             /*  ? ListView.builder(
                shrinkWrap: true,
                 controller: _scrollController,
                  
                  itemCount: snapshot.data.docs.length + 1,
                  itemBuilder: (context, index) {
                    if(index == snapshot.data.docs.length){
                      return Container(height: 70);
                    }
                    return MessageTile(
                        message: snapshot.data.docs[index]['message'],
                        sender: snapshot.data.docs[index]['sender'],
                        sentByMe: widget.userName ==
                            snapshot.data.docs[index]['sender']);
                  },
                )
              : Container(); */
              
                                            ? ListView.builder(
                                              shrinkWrap: true,
                                               controller: _scrollController,
                                                itemCount: snapshot.data.docs.length,
                                                itemBuilder: (context, index) {
                                               
                                                      if (snapshot.data.docs[index]['senderUID'] == context.read<UserDetailsCubit>().getUserId()) {
                                                        return GroupOwnMessageCard(
                                                          message: snapshot.data.docs[index]['message'],
                                                           isread: widget.isread,
                                                          time:snapshot.data.docs[index]['time'].toString(),
                                                          
                                                        );
                                                      } else {
                                                        return GroupReplyCard(
                                                          message: snapshot.data.docs[index]['message'],
                                                          time: snapshot.data.docs[index]['time'].toString(),
                                                        );
                                                      } 

                                                },
                                              )
                                            : Container( 
                                              child: Text(""), 
                                              );
        },
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "groupName": widget.groupName,
        "groupId": widget.groupId,
        "senderName": context.read<UserDetailsCubit>().getUserName(),
        "senderUID": context.read<UserDetailsCubit>().getUserId(),
        "senderFID": context.read<UserDetailsCubit>().getUserFirebaseId(),
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId()).sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
