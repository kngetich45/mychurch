import 'package:bevicschurch/app/routes.dart';
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../../../../features/chat/chatFirestoreDataSource.dart';
import '../../../../features/chat/chatRepository.dart';
import '../../../../features/chat/cubits/chatUsersCubit.dart';
import '../../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../../utils/constants.dart'; 

class ChatNewConversationList extends StatefulWidget{
  final String name;
  final String id;
 final String firebaseId;
 final  String profileURL;
 final  String mobile,senderIsPremier;
 final int isPremier;
  final Animation<double> listTileWidth;
  final Animation<Alignment> listSlideAnimation;
  final Animation<EdgeInsets> listSlidePosition;




  ChatNewConversationList ({ required this.name, required this.id, required this.firebaseId, required this.profileURL, required this.mobile, required this.isPremier,
   required this.listSlideAnimation,
   required this.listSlidePosition,
    required this.listTileWidth,
    required this.senderIsPremier,


    });
  @override
  _ChatNewConversationListState createState() => _ChatNewConversationListState();
   static Route<dynamic> route(RouteSettings routeSettings) { 
          Map arguments = routeSettings.arguments as Map;
      return CupertinoPageRoute(
         builder: (_) => BlocProvider<ChatUsersCubit>(
            create: (_) => ChatUsersCubit(ChatRepository()),
            child: ChatNewConversationList( 
                name: arguments['name'],
                id: arguments['id'],
                mobile: arguments['mobile'],
                firebaseId: arguments['firebaseId'],
                profileURL: arguments['profileURL'],
                senderIsPremier: arguments['senderIsPremier'],
                isPremier: arguments['isPremier'],
                listTileWidth: arguments['listTileWidth'],
                listSlideAnimation: arguments['listSlideAnimation'],
                listSlidePosition: arguments['listSlidePosition'],
            )));
  }
 

}

class _ChatNewConversationListState extends State<ChatNewConversationList> {
 

  @override
  Widget build(BuildContext context) {
    return  Container(
          alignment: widget.listSlideAnimation.value,
          margin: widget.listSlidePosition.value * 1,
          width: widget.listTileWidth.value,
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  InteractiveViewer(
                          panEnabled: false, // Set it to false
                          boundaryMargin: EdgeInsets.all(100),
                          minScale: 0.5,
                          maxScale: 2,
                          child: CircleAvatar(
                                        backgroundImage: NetworkImage(profileImage+widget.profileURL),
                                        maxRadius: 30,
                                      ),
                        ),
                  
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>
                                [
                                  Text(widget.name, style: TextStyle(fontSize: 19),),
                                  SizedBox(width: 5),
                                  widget.isPremier==1?
                                  Icon(Icons.verified, color: Colors.blue,size: 18,):Text("")

                                ]  
                          ), 
                          SizedBox(height: 6,),
                          Text(widget.mobile,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isPremier==1?FontWeight.normal:FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector( 
                              onTap: (){
                                 widget.senderIsPremier == "0" ?
                                showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('Premium Subscriptions'),
                                              content: const Text('You have free membership plan, Buy premium plan to send a message'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, 'ok');
                                                    Navigator.of(context).pushReplacementNamed(Routes.givingCategory); 
                                                    
                                                  },
                                                  child: const Text('Subscribe',style: TextStyle(color: Colors.red),),
                                                ),
                                              ],
                                            ),
                                )
                                :

                                _createPeerChat(); 
                            
                              },

                              child: Container(
                                  
                                margin: EdgeInsets.all(0),
                                width: 80,
                                height: 40,
                                child:  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                  child: Container(
                                    color: primaryColor,
                                    alignment: Alignment.center,
                                    child:Text("Say Hi!",style: TextStyle(fontSize: 12,color: Colors.white),),

                                  ),
                                  
                                ) 
                                // This trailing comma makes auto-formatting nicer for build methods.
                              )
                    )
                               
                  ]
              

            )
            
          ],
        ),
      );
     
  }


  
  _createPeerChat(){
          ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId())
            .createPeerChat(
              context.read<UserDetailsCubit>().getUserName(),
              context.read<UserDetailsCubit>().getUserFirebaseId(),
              widget.id+"_"+context.read<UserDetailsCubit>().getUserId(),
              context.read<UserDetailsCubit>().getUserId(),
              context.read<UserDetailsCubit>().getUserProfile().profileUrl!,
              widget.name,
              widget.firebaseId,
              widget.profileURL,
              widget.id,
              widget.mobile,
             // context.read<UserDetailsCubit>().getUserFirebaseId()+"_"+context.read<UserDetailsCubit>().getUserName(),
              //widget.firebaseId+"_"+widget.name,
              )
              .whenComplete(() => 
              {
              //  _isLoading =false
              });

     
        //   Navigator.of(context).pushNamed(Routes.chatHome);          
        //
        
      Navigator.of(context).pushReplacementNamed(Routes.chatDetail, arguments: {"senderFID":context.read<UserDetailsCubit>().getUserFirebaseId(),"sprofileURL":context.read<UserDetailsCubit>().getUserProfile().profileUrl!,
      "senderUID":context.read<UserDetailsCubit>().getUserId(), "senderName":context.read<UserDetailsCubit>().getUserName(),"receiverUID":widget.id,
      "receiverName":widget.name,"receiverFID":widget.firebaseId,"receiverMobile":widget.mobile,"rprofileURL":widget.profileURL,"isread":'1'});
 

      //  showSnackbar(context, Colors.green, "Account initated successfully");
  }


}