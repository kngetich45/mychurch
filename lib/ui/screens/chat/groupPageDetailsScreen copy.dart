import 'package:bevicschurch/features/chat/chatFirestoreDataSource.dart';
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes.dart';
import '../../../features/chat/chatRepository.dart';
import '../../../features/chat/cubits/chatCubit.dart';
import 'widget/message_tile.dart';

class GroupPageDetailsScreen extends StatefulWidget { 
  final String userName;
  final String groupId;
  final String groupName;
  final String userId;
  const GroupPageDetailsScreen({Key? key,
                   required this.userName,
                   required this.groupId,
                   required this.groupName,
                   required this.userId
                   }) : super(key: key);

  @override
  State<GroupPageDetailsScreen> createState() => _GroupPageDetailsScreenState();
    static Route<dynamic> route(RouteSettings routeSettings) { 
     Map arguments = routeSettings.arguments as Map;
      return CupertinoPageRoute(
         builder: (_) => BlocProvider<ChatCubit>(
            create: (_) => ChatCubit(ChatRepository()),
            child: GroupPageDetailsScreen(
              userName: arguments['userName'],
              groupId: arguments['groupId'],
             groupName: arguments['groupName'],
             userId: arguments['userId'], 
            )));
  }
}

class _GroupPageDetailsScreenState extends State<GroupPageDetailsScreen> {
   Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  @override
  void initState(){
    _getChatAdmin();
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

  @override
  Widget build(BuildContext context) {
    return    Scaffold(
       backgroundColor: Colors.white,
  
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
                                            "userName": widget.userName,
                                            "groupId": widget.groupId,
                                            "groupName": widget.groupName,
                                            "userId": widget.userId,
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
      body: Stack(
        children: <Widget>[
          // chat messages here
          chatMessages(),
          Container(
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
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.userName ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      ChatFirestoreDataSource().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
