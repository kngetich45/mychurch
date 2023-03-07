  
import 'package:bevicschurch/app/routes.dart';
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
 

class GroupTitle extends StatefulWidget {
  final String senderName;
  final String groupId;
  final String groupName;
  final String senderUserId;
  final String recentMessage;
  final String recentMessageTime;
  final String groupAdmin;
  final String isread;
  const GroupTitle({Key? key,
                   required this.senderName,
                   required this.groupId,
                   required this.groupName,
                   required this.senderUserId,
                    required this.recentMessage,
                   required this.recentMessageTime,
                   required this.groupAdmin,
                   required this.isread
                   }) : super(key: key);

  @override
  State<GroupTitle> createState() => _GroupTitleState();
}

class _GroupTitleState extends State<GroupTitle> {

  

 
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
        Navigator.of(context).pushNamed(Routes.groupPageDetail, 
        arguments: {
                     "senderName": widget.senderName,
                     "groupId": widget.groupId,
                     "groupName": widget.groupName,
                     "senderUID": widget.senderUserId,
                     "isread": widget.isread
                  });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
         
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: primaryColor,
            child: Text(
              widget.groupName.substring(0,1).toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500
              ),
            ),
          ),

          title: Row(
            children: [
              Expanded(
                child: Text(widget.groupName,
                    style: const TextStyle(fontWeight: FontWeight.bold),),
              ),
              Align(
                alignment: Alignment.centerRight,
                // child: Text(DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.fromMillisecondsSinceEpoch(sendTime)),
                child: Text(getTime(widget.recentMessageTime),
                    style: const TextStyle(fontWeight: FontWeight.normal),),
              )

            ],
          ), 

          subtitle: Text(widget.senderName + ": " + widget.recentMessage,
                     style: const TextStyle(fontSize: 13),),
                     
        ),
         
      ),
    );
    
  }
}