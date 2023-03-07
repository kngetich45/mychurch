import 'package:bevicschurch/features/chat/chatFirestoreDataSource.dart';
import 'package:bevicschurch/features/profileManagement/cubits/userDetailsCubit.dart';
import 'package:bevicschurch/ui/screens/chat/widget/showSnackBar.dart';
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../../../app/routes.dart';
import '../../../features/chat/chatRepository.dart';
import '../../../features/chat/cubits/chatCubit.dart';
import '../../../features/chat/cubits/chatUsersCubit.dart';
import '../../../features/profileManagement/cubits/updateUserDetailsCubit.dart';
import 'dart:async';
import '../../../features/profileManagement/profileManagementRepository.dart';
import 'CallPageScreen.dart';  
import 'cChat/chatHomePageScreen.dart'; 
import 'groupHomePageScreen.dart'; 

class ChatHomeScreen extends StatefulWidget {
  static const routeName = "/chatHome";
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
   static Route<dynamic> route(RouteSettings routeSettings) { 
      

            return CupertinoPageRoute(
                 builder: (context) => MultiBlocProvider(providers: [
              BlocProvider<ChatCubit>(
                  create: (_) =>
                      ChatCubit(ChatRepository())), 
              BlocProvider<ChatUsersCubit>(
                  create: (_) =>
                      ChatUsersCubit(ChatRepository())), 
              BlocProvider<UpdateUserDetailCubit>(
                  create: (context) => UpdateUserDetailCubit(
                        ProfileManagementRepository(),
                      )),
            ], child: ChatHomeScreen()));


  }
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  DateTime selectedDate = DateTime.now();
  int _selectedIndex  = 0;
  late String _title;
 Stream? groups;
bool _isLoading =false;
String groupName ="";
 

  @override
  void initState() { 
    _fetchUserDetails(); 
    _fetchEvents(); 
    super.initState();
  }

    _fetchUserDetails() async {  
        QuerySnapshot snapshot =
              await ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId())
                  .getUserData(context.read<UserDetailsCubit>().getUserId());
  
         if(snapshot.docs.isEmpty)
         {
            ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId())
            .updateUserData(
              context.read<UserDetailsCubit>().getUserName(),
              context.read<UserDetailsCubit>().getUserEmail()!, 
              context.read<UserDetailsCubit>().getUserId(),
              context.read<UserDetailsCubit>().getUserProfile().profileUrl!,);

         }        
    
      }


    _fetchEvents() {  
     _title = 'Church Groups';
  }
  void _onItemTapped(int index) {  
    setState(() {  
      _selectedIndex = index;   
      switch(index) { 
       case 0: { _title = 'Chats'; } 
       break; 
       case 1: { _title = 'Church Groups'; } 
       break;  
       case 2: { _title = 'Calls'; } 
       break; 
      }
    });  
  } 

  final List<Widget> _children = [
    
    ChatHomePageScreen(), 
    GroupHomePageScreen(),
    CallPageScreen()
  ]; 

  
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        
        title: Text(_title, style: TextStyle(fontSize: 18),),
        actions: [
           
          SizedBox(
            height: 38,
            width: 38,
            child: InkWell(
              highlightColor: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(32.0)),
              onTap: () {
                setState(() {
                //  selectedDate = selectedDate.add(new Duration(days: 1));
                 // _selecteddate = DateFormat('yyyy-MM-dd').format(selectedDate);
                });
              },
              child: Center(
                child: IconButton(
                  onPressed: () {
                  // Navigator.of(context).pushNamed(Routes.groupSearch);
              },
              icon: const Icon(
                Icons.search,
              ))
              ),
              
            ),
          ),
          SizedBox(width: 18,),
               PopupMenuButton<String>(
                  padding: EdgeInsets.only(right: 10),
                  onSelected: (value) {
                    if(value == 'new_group')
                    {
                      _popUpDialog(context);

                    }else if(value == 'search_group'){
                        Navigator.of(context).pushNamed(Routes.groupSearch);
 
                    }else if(value == 'settings'){
                        Navigator.of(context).pushNamed(Routes.profile);

                    }
                  },
                  itemBuilder: (BuildContext contesxt) {
                    return [
                      PopupMenuItem(
                        child: Text("New group"),
                        value: "new_group",
                      ),
                      PopupMenuItem(
                        child: Text("Search group"),
                        value: "search_group",
                      ),
                      PopupMenuItem(
                        child: Text("Media, links, and docs"),
                        value: "Media, links, and docs",
                      ), 
                      PopupMenuItem(
                        child: Text("Settings"),
                        value: "settings",
                      ),
                    ];
                  },
                ),
        ],
      ),
      body: Padding(
        
                padding: EdgeInsets.only(top: 0),
                child: _children[_selectedIndex],
          ),
   
        bottomNavigationBar: BottomNavigationBar(
         currentIndex: _selectedIndex,  
         onTap: _onItemTapped,   
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chats",
          ), 
           BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            label: "Church Groups",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: "Calls",
          ),
        ],
      ),
       

      
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
                             Navigator.of(context).pushNamed(Routes.groupSearch);
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

} 
 