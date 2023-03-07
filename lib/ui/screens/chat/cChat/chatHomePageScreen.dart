 
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/routes.dart';
import '../../../../features/chat/chatRepository.dart';
import '../../../../features/chat/cubits/chatUsersCubit.dart';
import '../../../../features/chat/chatFirestoreDataSource.dart'; 
import '../../../../features/profileManagement/cubits/userDetailsCubit.dart'; 
import 'chatTitle.dart';
 

class ChatHomePageScreen extends StatefulWidget {
  const ChatHomePageScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomePageScreen> createState() => _ChatHomePageScreenState(); 
  static Route<dynamic> route(RouteSettings routeSettings) { 
      // Map arguments = routeSettings.arguments as Map;
      return CupertinoPageRoute(
         builder: (_) => BlocProvider<ChatUsersCubit>(
            create: (_) => ChatUsersCubit(ChatRepository()),
            child: ChatHomePageScreen()));
  }
}

class _ChatHomePageScreenState extends State<ChatHomePageScreen> with TickerProviderStateMixin  {
 
var animateStatus = 0;
Stream? groups; 
String groupName ="";
 

  @override
  void initState() {
    super.initState();

 //   _gettingUserData();
 
  }

  @override
  void dispose() {
  /*   _screenController.dispose();
    _buttonController.dispose();*/
    super.dispose(); 
  }

 /*  String _getId(String res){
       return res.substring(0, res.indexOf("_"));
     
  }
  String _getName(String res){
       return res.substring(res.indexOf("_")+1);
     
  } */


/*   _gettingUserData() async{
  //list of snapshot on the stream 
    await ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId())
        .getResentGroups(context.read<UserDetailsCubit>().getUserName())
        .then((snapshot){
        setState((){
          
          groups = snapshot;
        });
        }); 
     
  } */
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      body: _chatListBuild(context),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            Navigator.of(context).pushNamed(Routes.newChat);
        },
        elevation: 0,
        backgroundColor: primaryColor,
        child: const Icon(Icons.whatsapp, color: Colors.white,size: 30,), 
      
      ),
      
    );
    
  }

 _chatListBuild(BuildContext context){
 
//return Hive.box(chatBox).get(resentChatsKey, defaultValue: []);
  return StreamBuilder(
    stream: ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId()).getResentChats(context.read<UserDetailsCubit>().getUserName()),
    //builder:(context, AsyncSnapshot snapshot) {
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if(snapshot.hasData){
       // print('data ${snapshot.data[0].data}');
        if(snapshot.data!.docs.isEmpty)
        {   return _noGroupWidget(); 

        }else{
       
              return ListView(
                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                  return ChatTitle(
                                    senderName: data['senderName'],
                                    senderProfile: data['senderProfile'],
                                    senderFID: data['senderFID'],
                                    senderUID: data['senderUID'],
                                    receiverUID: data['receiverUID'],
                                    receiverMobile: data['receiverMobile'],
                                    receiverFID: data['receiverFID'],
                                    receiverName: data['receiverName'],
                                    peerName: data['peerName'],
                                    receiverProfile: data['receiverProfile'],
                                    recentChat: data['recentChat'], 
                                    timeStamp: data['timeStamp'],
                                    isread: data['isread'], 
                                    isNotRead: data['isNotRead'].toString(), 
                                    currentFiD: context.read<UserDetailsCubit>().getUserFirebaseId(),   
                                    
                                  );
                                }).toList(),
                    );

         
        }

      }
      else{
         return const Center(child:CircularProgressIndicator(color: Colors.red),);
      }
    },
  );
 
  }

 _noGroupWidget(){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
              //  _popUpDialog(context);

              Navigator.of(context).pushNamed(Routes.newChat);



              },
              child: Icon(Icons.add_circle,color: Colors.grey[700], size: 75,)
              ),
            const SizedBox(height: 20,),
            const Text("You've no chats, tap on the add icon to initiate a conversation or also search from the search from the top search button. ",
            
            textAlign: TextAlign.center,)

          ],
        ),

      );

  }

 
}

