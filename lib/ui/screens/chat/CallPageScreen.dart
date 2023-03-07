 
import 'package:flutter/material.dart';
 

class CallPageScreen extends StatefulWidget {
  const CallPageScreen({Key? key}) : super(key: key);

  @override
  State<CallPageScreen> createState() => _CallPageScreenState();
}

class _CallPageScreenState extends State<CallPageScreen> {

 
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      body: SingleChildScrollView(
        
        physics: BouncingScrollPhysics(),
        child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SafeArea(
                     
                       
                        child:  Padding(
                              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  hintStyle: TextStyle(color: Colors.grey.shade600),
                                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  contentPadding: EdgeInsets.all(8),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade100
                                      )
                                  ),
                                ),
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