import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupOwnMessageCard extends StatelessWidget {
  const GroupOwnMessageCard({Key? key, required this.message, required this.time, required this.isread }) : super(key: key);
  final String message;
  final String time,isread;

  @override
  Widget build(BuildContext context) {

 String getTime(String timestamp) {
          DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
          DateFormat format;
          if (dateTime.difference(DateTime.now()).inMilliseconds <= 86400000) {
            format = DateFormat('Hm');
          } else {
            format = DateFormat.yMd('en_US');
          }
          return format
              .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));
  }


    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Color(0xffdcf8c6),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 30,
                  top: 5,
                  bottom: 25,
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
                
              Positioned(
                bottom: 4,
                right: 10,
                 
                child: Row(
                  children: [
                    Text(
                    getTime(time),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    isread == "1"?
                        Icon(
                          Icons.done,
                          size: 20,
                        )
                    :
                      Icon(
                        Icons.done_all,
                        color: Colors.blue,
                        size: 20,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}