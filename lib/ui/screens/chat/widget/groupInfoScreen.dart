import 'package:bevicschurch/features/chat/chatFirestoreDataSource.dart';
import 'package:bevicschurch/features/profileManagement/cubits/userDetailsCubit.dart';
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/routes.dart';
import '../../../../features/chat/chatRepository.dart';
import '../../../../features/chat/cubits/chatCubit.dart';

class GroupInfoScreen extends StatefulWidget {
 
 // final String userName;
  final String groupId;
  final String groupName;
  final String userId;
  final String adminName;
  const GroupInfoScreen({Key? key,
                   //required this.userName,
                   required this.groupId,
                   required this.groupName,
                   required this.userId,
                    required this.adminName
                   }) : super(key: key);

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
   static Route<dynamic> route(RouteSettings routeSettings) { 
     Map arguments = routeSettings.arguments as Map;
      return CupertinoPageRoute(
         builder: (_) => BlocProvider<ChatCubit>(
            create: (_) => ChatCubit(ChatRepository()),
            child: GroupInfoScreen(
            //  userName: arguments['userName'],
              groupId: arguments['groupId'],
              groupName: arguments['groupName'],
              userId: arguments['senderUserId'], 
              adminName: arguments['adminName'], 
            )));
     }
  }

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  Stream? members;
  @override
  void initState() {
     _getMembers();
    super.initState();
  }

  _getMembers() async {
               ChatFirestoreDataSource(uid: context.read<UserDetailsCubit>().getUserFirebaseId())
                    .getGroupMembers(widget.groupId)
                    .then((val){
                    setState(() {
                      members = val;
                    });
                });
  }

  String _getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String _getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        title: const Text("Group Info"),
        actions: [
          IconButton(onPressed: (){
            showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Exit"),
                        content:
                            const Text("Are you sure you exit the group? "),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              ChatFirestoreDataSource(
                                      uid: context.read<UserDetailsCubit>().getUserFirebaseId())
                                  .toggleGroupJoin(
                                      widget.groupId,
                                     // _getName(widget.adminName),
                                     context.read<UserDetailsCubit>().getUserName(),
                                      widget.groupName)
                                  .whenComplete(() {

                                Navigator.of(context).pushNamed(Routes.chatHome);

                              });
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
                    }, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body:  Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).primaryColor.withOpacity(0.2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Admin: ${_getName(widget.adminName)}")
                    ],
                  )
                ],
              ),
            ),
            _memberList(),
          ],
        ),
      ),
     
    );
  }

   _memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          _getName(snapshot.data['members'][index])
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(_getName(snapshot.data['members'][index])),
                      subtitle: Text(_getId(snapshot.data['members'][index])),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        }
      },
    );
  }
}