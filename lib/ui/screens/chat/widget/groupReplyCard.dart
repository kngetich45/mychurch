import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupReplyCard extends StatelessWidget {
  const GroupReplyCard({Key? key, required this.message, required this.time}) : super(key: key);
  final String message;
  final String time;

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
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // color: Color(0xffdcf8c6),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 50,
                  top: 5,
                  bottom: 20,
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
                child: Text(
                  getTime(time),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}