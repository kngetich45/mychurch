 
import 'package:bevicschurch/ui/screens/chat/widget/groupTitle.dart';
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/chat/chatFirestoreDataSource.dart';
import '../../../features/chat/chatRepository.dart';
import '../../../features/chat/cubits/chatUsersCubit.dart';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import 'widget/showSnackBar.dart';
 

class GroupHomePageScreen extends StatefulWidget {
  const GroupHomePageScreen({Key? key}) : super(key: key);

  @override
  State<GroupHomePageScreen> createState() => _GroupHomePageScreenState(); 
  static Route<dynamic> route(RouteSettings routeSettings) { 
      // Map arguments = routeSettings.arguments as Map;
      return CupertinoPageRoute(
         builder: (_) => BlocProvider<ChatUsersCubit>(
            create: (_) => ChatUsersCubit(ChatRepository()),
            child: GroupHomePageScreen()));
  }
}

class _GroupHomePageScreenState extends State<GroupHomePageScreen> with TickerProviderStateMixin  {
/*  late Animation<double> containerGrowAnimation;
late AnimationController _screenController;
 late  AnimationController _buttonController;
 late  Animation<double> buttonGrowAnimation;
late Animation<double> listTileWidth;
 late  Animation<Alignment> listSlideAnimation;
late Animation<Alignment> buttonSwingAnimation;
 late  Animation<EdgeInsets> listSlidePosition;
late  Animation<Color?> fadeScreenAnimation; */
var animateStatus = 0;
Stream? groups;
bool _isLoading =false;
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
/* 
  String _getId(String res){
       return res.substring(0, res.indexOf("_"));
     
  }
  String _getName(String res){
       return res.substring(res.indexOf("_")+1);
     
  }


  _gettingUserData() async{
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
          _popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: primaryColor,
        child: const Icon(Icons.whatsapp, color: Colors.white,size: 30,), 
      
      ),
      
    );
    
  }

 _chatListBuild(BuildContext context){
 

  return StreamBuilder(
    stream: ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId()).getResentGroups(context.read<UserDetailsCubit>().getUserName()),
    //builder:(context, AsyncSnapshot snapshot) {
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if(snapshot.hasData){
       // print('data ${snapshot.data[0].data}');
        if(snapshot.hasError)
        {/* 
          if(snapshot.data['members'].length != 0)
          { */
           /*  return ListView.builder(
              itemCount: snapshot.data['members'].length,
              itemBuilder: (context, index){
                return GroupTitle(
                     userName: _getName(snapshot.data['members'][index]),
                     groupId: snapshot.data['groupId'],
                      groupName: snapshot.data['groupName'],
                     recentMessage: snapshot.data['recentMessage'],
                      userId: snapshot.data['recentMessageSenderUserId'],
                      recentMessageTime: snapshot.data['recentMessageTime'],
                   //    groupId: _getId(snapshot.data['members'][index]),
                   //  groupName: _getName(snapshot.data['members'][index]),
                     recentMessageSender: snapshot.data['recentMessageSender']
                  );
              },
            ); */

            
                  return _noGroupWidget();

/* 

          }else{
            return _noGroupWidget();
          } */
 
        }else{
              return ListView(
                                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                  return GroupTitle(
                                   senderName: data['recentSenderName'],
                                   groupId: data['groupId'],
                                    groupName: data['groupName'],
                                    recentMessage: data['recentMessage'],
                                    senderUserId: data['recentSenderUserId'],
                                    recentMessageTime: data['recentMessageTime'],
                                    isread: data['isread'],
                                //    groupId: _getId(snapshot.data['members'][index]),
                                //  groupName: _getName(snapshot.data['members'][index]),
                                     groupAdmin: data['admin']
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

  _popUpDialog(BuildContext context){
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: ((context, setState) {
               return AlertDialog(
                    title: const Text(
                      "Create a group",
                      textAlign: TextAlign.left,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [_isLoading == true ? Center(
                        child: CircularProgressIndicator(color: primaryColor)) 
                        : TextField(
                          onChanged: (value){
                            setState(() {
                              groupName = value;
                            });
                
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                              borderRadius: BorderRadius.circular(20)
                            )
                          ),
                
                        ),
                      ],
                    ),
                
                    actions: [
                      ElevatedButton(onPressed: (){ 
                        Navigator.of(context).pop();
                      },
                        style: ElevatedButton.styleFrom(primary: primaryColor),
                        child: const Text("CANCEL")
                      ),
                      ElevatedButton(onPressed: () async{ 
                          if(groupName != "")
                          {
                            setState(() {
                              _isLoading = true;
                            });
                          }
                          ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId())
                          .createGroup(
                            context.read<UserDetailsCubit>().getUserName(),
                            context.read<UserDetailsCubit>().getUserFirebaseId(),
                            groupName,
                            context.read<UserDetailsCubit>().getUserId())
                            .whenComplete(() => 
                            {
                              _isLoading =false
                            });
                            Navigator.of(context).pop();
                            showSnackbar(context, Colors.green, "Group created successfully");
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: const Text("CREATE")
                      ),
                    ],
                  );
            
          }),
       
        );
      }
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
                _popUpDialog(context);
              },
              child: Icon(Icons.add_circle,color: Colors.grey[700], size: 75,)
              ),
            const SizedBox(height: 20,),
            const Text("You've not joined any groups, tap on the add icon to create a group or also search from the search from the top search button. ",
            
            textAlign: TextAlign.center,)

          ],
        ),

      );

  }

 
}

