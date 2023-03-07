 
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../../../../features/chat/models/ChatMessageModel.dart';
import '../../../../utils/constants.dart';

class ResentChatConversationList extends StatefulWidget{
    
 final ChatMessageModel chats;
  final DocumentReference<ChatMessageModel> reference;
   final Animation<double> listTileWidth;
  final Animation<Alignment> listSlideAnimation;
  final Animation<EdgeInsets> listSlidePosition;


  ResentChatConversationList ({ required this.chats,required this.reference,required this.listSlideAnimation, required this.listSlidePosition, required this.listTileWidth,});
  @override
  _ResentChatConversationListState createState() => _ResentChatConversationListState();
 

}

class _ResentChatConversationListState extends State<ResentChatConversationList> {
  
    @override
  void initState() {
     //_lastchatMessage();
    super.initState();
  }
   
  
  /*  _lastchatMessage(){

      Future.delayed(Duration.zero,()  async{
       Query collectionRef = FirebaseFirestore.instance.collection(chatMessage).orderBy('sendTime', descending: true).limitToLast(1);
       QuerySnapshot querySnapshot = await collectionRef.get();
        final temp = querySnapshot.docs.map((doc) => doc.data()).toList();

       return temp;
     });
   } */

  @override
  Widget build(BuildContext context) {
              final Timestamp timestamp = widget.chats.sendTime;
              final DateTime dateTime = timestamp.toDate();
              final currentDataTime = DateFormat('K:mm').format(dateTime);
    
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
                                        backgroundImage: NetworkImage(profileImage+ widget.chats.recepientImage),
                                       //backgroundColor: Colors.blue,
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
                                  Text(widget.chats.name, style: TextStyle(fontSize: 19),),
                                  SizedBox(width: 5),
                                /*   widget.chats.isRead=="1"?
                                  Icon(Icons.verified, color: Colors.blue,size: 18,):Text("") */

                                ]  
                          ), 
                          SizedBox(height: 6,),

                        Row(
                            children: <Widget>
                                [ 
                                  SizedBox(width: 5), 
                                  Icon(Icons.done_all, color: widget.chats.isRead=="0"? Colors.blue: Colors.grey,size: 18,),
                               
                                SizedBox(width: 6,), 
                                Text(widget.chats.messageContent,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: FontWeight.normal ),),
                                   

                                ]  
                          ),
                           
                        ],
                      ),
                    ),
                  ),
                   SizedBox(width: 16,), 
                           Column(
                            children: <Widget>
                                [   
                                  
                                Text(currentDataTime,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight:  FontWeight.normal),), 
                                widget.chats.isRead=="1"?
                                Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(100),
                                     color: primaryColor,
                                  ),
                                    child: Center(child: Text("8", style: TextStyle(color: Colors.white),)),
                                   )
                                   :
                                   Container()
                                ]  
                          ),

                ],
              ),
            ),
         /*    Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector( 
                              onTap: (){
                                widget.isPremier==1 &&  widget.senderIsPremier == "0" ?
                                showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('Premium Subscriptions'),
                                              content: const Text('You have free membership plan, Buy premium plan to send a continue'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, 'OK'),
                                                  child: const Text('Subscribe',style: TextStyle(color: Colors.red),),
                                                ),
                                              ],
                                            ),
                                )
                                :
                             Navigator.of(context).pushNamed(Routes.chatDetail, arguments: {"id":widget.id,"name":widget.name,"firebaseId":widget.firebaseId,"mobile":widget.mobile,"profileURL":widget.profileURL});

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
              

            ) */
            
          ],
        ),
      );
     
  }
}