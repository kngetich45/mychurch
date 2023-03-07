 
import 'package:bevicschurch/ui/styles/colors.dart'; 
import 'package:flutter/material.dart';

class AudioCommentScreen extends StatefulWidget{
 
  @override
  _AudioCommentScreenState createState() => _AudioCommentScreenState();
}

class _AudioCommentScreenState extends State<AudioCommentScreen> {
  @override
  Widget build(BuildContext context) { 
      return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back
          ),
          onPressed: () {
            //  Navigator.of(context).pushNamed(Routes.dashboard);
            Navigator.pop(context);
          },
        ),

      ),
      backgroundColor: Color.fromARGB(255, 243, 241, 241),
      body: Container(  
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[

              Expanded( 
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                 Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                          InteractiveViewer(
                              panEnabled: false, // Set it to false
                              boundaryMargin: EdgeInsets.all(50),
                              minScale: 0.5,
                              maxScale: 2,
                              child: CircleAvatar(
                                            backgroundImage: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                                            maxRadius: 30,
                                          ),
                            ) 
                                 
                          ]
                

                        ),
                        SizedBox(width: 10,),
                
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("widget.name", style: TextStyle(fontSize: 14),),
                            SizedBox(height: 3,),
                             Text("1 day",style: TextStyle(fontSize: 10,fontWeight: FontWeight.normal,color: grey_60),),
                            SizedBox(height: 3,),
                            Text("widget.messageText, widget.messageTextwidget.messageTextwidget.messageTextwidget.messageTextwidget.messageTextwidget.messageText",style: TextStyle(fontSize: 15,color: Colors.grey.shade800, fontWeight: FontWeight.normal ),),
                          ],
                        ),
                      ),
                    ), 
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.more_vert, color: Colors.black), onPressed: () {  }, 
                          ),
                          
                    ]
                

            )
            
          ],
            ),
              ),

           Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){},
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: primaryColor,
                    elevation: 0,
                  ),
                ],
                
              ),
            ),
          ),

            ],
            

            
          )
            
      )
      );
      
  }
}