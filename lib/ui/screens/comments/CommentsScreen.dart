import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../app/appLocalization.dart';
import '../../../app/routes.dart';
import '../../../features/comments/CommentsRepository.dart';
import '../../../features/comments/cubits/CommentsCubit.dart';
import '../../../features/mediaPlayers/MediaPlayerRepository.dart';
import '../../../features/mediaPlayers/cubits/MediaPlayerCubit.dart';
import '../../../features/mediaPlayers/models/MediaPlayerModel.dart';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../features/profileManagement/models/userProfile.dart';
import '../../../i18n/strings.g.dart'; 
import '../../../ui/widgets/CommentsItem.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/uiUtils.dart';
import 'CommentsMediaHeader.dart';
import '../../widgets/circularProgressContainner.dart';
import '../../widgets/errorContainer.dart';   

class CommentsScreen extends StatefulWidget {
  static String routeName = "/comments";
  final MediaPlayerModel mediaItem;
  // final CommentsModel item;
  final int? commentCount;
  
  CommentsScreen({Key? key, required this.mediaItem, this.commentCount}) : super(key: key);

  @override
 // _CommentsScreenState createState() => _CommentsScreenState();
   State<CommentsScreen> createState() => _CommentsScreenState();
 static Route<dynamic> route(RouteSettings routeSettings){ 
         final arguments = routeSettings.arguments as Map<String, dynamic>?;
        // Map arguments = routeSettings.arguments as Map;
       return CupertinoPageRoute(
        builder: (_) => MultiProvider(
                providers: [
                      BlocProvider<MediaPlayerCubit>(
                      create: (_) => MediaPlayerCubit(MediaPlayerRepository())),
                      BlocProvider<CommentsCubit>(
                      create: (_) => CommentsCubit(CommentsRepository())),
                     
                      ],
               child: CommentsScreen(
                mediaItem: arguments!['item'],
               commentCount: arguments['commentCount'],
        ),
            ));
  } 

  
}

class _CommentsScreenState extends State<CommentsScreen> {
bool sendButton = false;
 

  @override
  void initState() {
      context.read<CommentsCubit>().getCommentsC(  
                    comentsId: '0',
                    userId: context.read<UserDetailsCubit>().getUserId(),
                    userEmail: context.read<UserDetailsCubit>().getUserEmail(),
                    mediaId: widget.mediaItem.id.toString(),
      );
    super.initState();
  }

final TextEditingController inputController = new TextEditingController();
 
        makeComment(text){

                 context.read<CommentsCubit>().getMakeCommentsC(  
                    media: widget.mediaItem.id.toString(),
                    userId: context.read<UserDetailsCubit>().getUserId(),
                    userEmail: context.read<UserDetailsCubit>().getUserEmail(),
                    content: text,
       );

 }

 
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
          Image.asset(
            "assets/images/backgroundChat.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ), 
        Scaffold(
        backgroundColor: Color.fromARGB(228, 255, 251, 251),
        appBar: AppBar(
          title: Text(widget.mediaItem.title.toString()),
          backgroundColor: primaryColor,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 1),
         // child: SingleChildScrollView(
            child: getCommentssBody(context),
          //),
        ),
      ),
      ],
    );
  }
  
  Widget getCommentssBody(BuildContext context) {
    print(widget.mediaItem.toString());

   
    UserProfile? userdata = context.read<UserDetailsCubit>().getUserProfile();


    return WillPopScope(
      onWillPop: () async {
         Navigator.pop(
           context, 
           widget.mediaItem.commentsCount.toString()
          
            );
        return false;
      },
 

      child: Container(
                child: Column(
                      children: <Widget>[
                        CommentsMediaHeader(object: widget.mediaItem),
                        Container(height: 5),
                        Expanded(
                          child: _commentsLists(context),
                        ),
                        
                        // ignore: unnecessary_null_comparison
                        userdata == null
                            ? Container(
                                height: 50,
                                child: Center(
                                    child: ElevatedButton(
                                        child: Text(t.logintoaddcomment),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacementNamed(Routes.login);
                                        })),
                              )
                            :   

                                     Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              height: 65,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context).size.width - 60,
                                                        child: Card(
                                                          margin: EdgeInsets.only(
                                                              left: 5, right: 2, bottom: 8),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(25),
                                                          ),
                                                          child: TextFormField(
                                                            controller: inputController,
                                                           // focusNode: focusNode,
                                                            textAlignVertical: TextAlignVertical.top,
                                                            keyboardType: TextInputType.multiline,
                                                            maxLines: 6,
                                                            minLines: 1,
                                                            onChanged: (value) {
                                                              
                                                            if (value.length > 0) {
                                                                setState(() {
                                                                  sendButton = true;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  sendButton = false;
                                                                });
                                                              }  
                                                            },
                                                            decoration: InputDecoration(
                                                              border: InputBorder.none,
                                                              hintText: "Type a message",
                                                              hintStyle: TextStyle(color: Colors.grey),
                                                              
                                                              contentPadding: EdgeInsets.all(5),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                          bottom: 8,
                                                          right: 2,
                                                          left: 2,
                                                        ),
                                                        child: CircleAvatar(
                                                          radius: 25,
                                                          backgroundColor:  sendButton ? primaryColor : Colors.grey,
                                                          child: IconButton(
                                                            icon: Icon(
                                                              sendButton ? Icons.send : Icons.send,
                                                              
                                                              color: Colors.white,
                                                            ),
                                                            onPressed: () {
                                                              
                                                              if (sendButton) {
                                                                String text = inputController.text;
                                                                      if (text != "") {
                                                                          makeComment(text);

                                                                      }
                                                                 inputController.text = "";
                                                                setState(() {
                                                                  
                                                                  sendButton = false;
                                                                });
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  //show ? emojiSelect() : Container(),
                

                                                // emojiSelect()
                                                ],
                                              ),
                                            ),
                                          ),
 
                      ],
                    ),
              ),
      
    );
  }
 
  Widget _commentsLists (BuildContext context) {
  
     return BlocConsumer<CommentsCubit, CommentsState>(
        bloc: context.read<CommentsCubit>(),
        listener: (context, state) {
          if (state is  CommentsFailure) {
            if (state.errorMessage == unauthorizedAccessCode) {
              //
              print(state.errorMessage);
              UiUtils.showAlreadyLoggedInDialog(context: context);
            }
          }
        },
        builder: (context, state) {
          if (state is  CommentsFetchInProgress || state is  CommentsInitial) {
            return Center(
              child: CircularProgressContainer(
                useWhiteLoader: false,
              ),
            );
          }
          if (state is CommentsFailure) {
            return ErrorContainer(
              showBackButton: false,
              errorMessageColor: Theme.of(context).primaryColor,
              showErrorImage: true,
              errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                convertErrorCodeToLanguageKey(state.errorMessage),
              ),
              onTapRetry: () {
                context.read<CommentsCubit>().getCommentsC(  
                    comentsId: '0',
                    userId: context.read<UserDetailsCubit>().getUserId(),
                    userEmail: context.read<UserDetailsCubit>().getUserEmail(),
                    mediaId: widget.mediaItem.id.toString(),
                    );
              },
            );
          }
          final commentsList = (state as CommentsSuccess).commentsList;
        
            return Container(
              color: Colors.white,
              child: ListView.separated( 
                         itemCount: commentsList.length,
                         reverse: true,
                          separatorBuilder: (BuildContext context, int index) =>
                       Divider(height: 1, color: Colors.grey),
                        itemBuilder: ( context,index) {
                   
                       bool isUser(String? email) {
                          // ignore: unnecessary_null_comparison
                          if (context.read<UserDetailsCubit>().getUserProfile() == null) return false;
                          return email == context.read<UserDetailsCubit>().getUserEmail();
                        }  
                        return CommentsItem(
                          isUser: isUser(context.read<UserDetailsCubit>().getUserEmail()), 
                              index: index,
                              object: commentsList[index],
                        );
                      }
                  //  },
                  ),
            );
            });



 
  }
}
