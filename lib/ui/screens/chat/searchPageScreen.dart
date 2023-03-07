import 'package:bevicschurch/features/chat/chatFirestoreDataSource.dart';
import 'package:bevicschurch/features/profileManagement/cubits/userDetailsCubit.dart'; 
import 'package:bevicschurch/ui/screens/chat/widget/showSnackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes.dart';
import '../../../features/chat/chatRepository.dart';
import '../../../features/chat/cubits/chatUsersCubit.dart'; 

class SearchPageScreen extends StatefulWidget {
  const SearchPageScreen({Key? key}) : super(key: key);

  @override
  State<SearchPageScreen> createState() => _SearchPageScreenState();
   static Route<dynamic> route(RouteSettings routeSettings) { 
      // Map arguments = routeSettings.arguments as Map;
      return CupertinoPageRoute(
         builder: (_) => BlocProvider<ChatUsersCubit>(
            create: (_) => ChatUsersCubit(ChatRepository()),
            child: SearchPageScreen()));
  }
}

class _SearchPageScreenState extends State<SearchPageScreen> {

  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
    QuerySnapshot? allSnapshot;
  bool hasUserSearched = false;
  //String userName = "";
  bool isJoined = false;
 

  @override
  void initState() {
     initiateLoadData();
    super.initState(); 
  }

   
   
   initiateLoadData() async { 
      setState(() {
       isLoading = true;
      });
      await ChatFirestoreDataSource()
          .getAllGroup()
          .then((snapshot) {
        setState(() {
          allSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = false;
        });
      });
    
  }

   

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {

     return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Search",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search groups....",
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                )
              : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await ChatFirestoreDataSource()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched && isLoading == false
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                context.read<UserDetailsCubit>().getUserName(),
                searchSnapshot!.docs[index]['groupId'],
                searchSnapshot!.docs[index]['groupName'],
                searchSnapshot!.docs[index]['admin'],
                searchSnapshot!.docs[index]['isread'],
                searchSnapshot!.docs[index]['recentSenderUserId'],
              );
            },
          )
        : //Container(child: Text("data"),);
        ListView.builder(
            shrinkWrap: true,
            itemCount: allSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupMainTile(
                context.read<UserDetailsCubit>().getUserName(),
                allSnapshot!.docs[index]['groupId'],
                allSnapshot!.docs[index]['groupName'],
                allSnapshot!.docs[index]['admin'],
                allSnapshot!.docs[index]['isread'],
                allSnapshot!.docs[index]['recentSenderUserId'],
              );
            },
          );
  }

  joinedOrNot(
      String userName, String groupId, String groupname, String admin) async {
    await ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId())
        .isUserJoined(groupname, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin, String isread, String senderUserId) {
    // function to check whether user already exists in group
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title:
          Text(groupName, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId())
              .toggleGroupJoin(groupId, userName, groupName);
          if (isJoined) {
            setState(() {
              isJoined = !isJoined;
            });
            showSnackbar(context, Colors.green, "Successfully joined he group");
            Future.delayed(const Duration(seconds: 2), () {
               Navigator.of(context).pushNamed(Routes.groupPageDetail, 
                          arguments: {
                                      "senderName": userName,
                                      "groupId": groupId,
                                      "groupName": groupName,
                                      "senderUID": senderUserId,
                                       "isread": isread
                                    }); 
              
            });
          } else {
            setState(() {
              isJoined = !isJoined;
              showSnackbar(context, Colors.red, "Left the group $groupName");
            });
          }
        },
        child: isJoined
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Joined",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text("Join Now",
                    style: TextStyle(color: Colors.white)),
              ),
      ),
    );
  }


    Widget groupMainTile(
      String userName, String groupId, String groupName, String admin, String isread, String senderUserId) {
    // function to check whether user already exists in group
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title:
          Text(groupName, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
         // await ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId())
         //     .toggleGroupJoin(groupId, userName, groupName);


            
         await ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId())
              .isUserJoined(groupName, groupId, userName)
              .then((value) {

                if(value == true)
                {
                   Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context).pushNamed(Routes.groupPageDetail, 
                          arguments: {
                                      "senderName": userName,
                                      "groupId": groupId,
                                      "groupName": groupName,
                                      "senderUID": senderUserId,
                                       "isread": isread
                         }); 
              
            }); 

                }else{
                  showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Not a member'),
                              content: const Text('Do you wish to join?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'ok');
                                      ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId())
                                       .toggleGroupJoin(groupId, userName, groupName);
                                    Navigator.of(context).pushReplacementNamed(Routes.chatHome); 
                                    
                                  },
                                  child: const Text('Join',style: TextStyle(color: Colors.red),),
                                ),
                              ],
                            ),
                );

                }
                
               }); 
          
        },
        child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "View",
                  style: TextStyle(color: Colors.white),
                ),
              )
            
      ),
    );
  }
}