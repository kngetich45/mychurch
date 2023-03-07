  
import 'package:bevicschurch/app/routes.dart';
import 'package:bevicschurch/ui/styles/colors.dart'; 
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
 

class ChatTitle extends StatefulWidget {
  final String senderName;
  final String senderProfile;
  final String senderFID;
  final String receiverName;
  final String senderUID;
  final String receiverFID;
  final String peerName;
  final String receiverProfile; 
   final String recentChat; 
  final String timeStamp; 
 final String receiverUID; 
 final String receiverMobile; 
  final String isNotRead; 
 final String isread; 
 final String currentFiD; 

  const ChatTitle({Key? key,
                   required this.senderName,
                   required this.senderProfile,
                   required this.senderFID,
                   required this.receiverName,
                    required this.peerName,
                   required this.receiverProfile, 
                    required this.recentChat,
                   required this.timeStamp, 
                   required this.senderUID,
                   required this.receiverFID,
                   required this.receiverUID,
                   required this.receiverMobile,
                   required this.isNotRead,
                   required this.isread,
                    required this.currentFiD,
                   }) : super(key: key);

  @override
  State<ChatTitle> createState() => _ChatTitleState();
}

class _ChatTitleState extends State<ChatTitle> {

  

 
  @override
  Widget build(BuildContext context) {


  String getTime(String timestamp) {
          DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
          DateFormat format;
          if (dateTime.difference(DateTime.now()).inMilliseconds <= 86400000) {
            format = DateFormat('jm');
          } else {
            format = DateFormat.yMd('en_US');
          }
          return format
              .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));
  }

 

    return GestureDetector(
      onTap: (){

          Navigator.of(context).pushNamed(Routes.chatDetail, 
          arguments: {
              "id":widget.receiverUID,
              "senderName":widget.senderName,
              "receiverName":widget.receiverName,
              
              "receiverUID":widget.receiverUID,
              "receiverFID":widget.receiverFID,
              "receiverMobile":widget.receiverMobile,
              "rprofileURL":widget.receiverProfile,
              "senderUID":widget.senderUID,
              "senderFID":widget.senderFID,
              "sprofileURL":widget.senderProfile,
              "isread":widget.isread
            });
 
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
         
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: primaryColor,
            backgroundImage: NetworkImage(widget.senderProfile),
            /* child: Text( 
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500
              ),
            ), */
          ),

          title: Row(
            children: [
              Expanded(
                child: Text(widget.senderFID == widget.currentFiD? widget.receiverName: widget.senderName,
                    style: const TextStyle(fontWeight: FontWeight.bold),),
              ),
              Align(
                alignment: Alignment.centerRight,
                // child: Text(DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.fromMillisecondsSinceEpoch(sendTime)),
                child: Text(getTime(widget.timeStamp),
                    style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),),
              )

            ],
          ), 

          subtitle:  Row(
                      children: [
                          widget.senderFID == widget.currentFiD?
                                  widget.isread =="1"?
                                           widget.recentChat ==""?  
                                               Container()
                                            : 
                                               Icon( Icons.done, size: 18,)
                                   :
                                      Icon( Icons.done_all, color: Colors.blue, size: 18,) 
                              :
                                 Container(),

                                  Expanded( 
                                        child: Text(widget.recentChat,  style: const TextStyle(fontSize: 13),), 
                                  ),
                                widget.isNotRead !="0" && widget.receiverFID == widget.currentFiD?

                                    Container(
                                      margin: EdgeInsets.all(0),
                                      width: 25,
                                      height: 25,
                                      child:  ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                        child: Container(
                                          color: primaryColor,
                                          alignment: Alignment.center,
                                          child:Text(widget.isNotRead,style: TextStyle(fontSize: 12,color: Colors.white),),

                                        ),
                                        
                                      )
                                      )

                               :
                               
                              Container()


                        /* Align(
                          alignment: Alignment.centerRight,
                          // child: Text(DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.fromMillisecondsSinceEpoch(sendTime)),
                          child: Text(getTime(widget.timeStamp),
                              style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),),
                        ) */

                      ],
                    ), 
                     
        ),
         
      ),
    );
    
  }
}