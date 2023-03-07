import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/appLocalization.dart';
import '../../../../features/chat/chatRepository.dart';
import '../../../../features/chat/cubits/chatUsersCubit.dart';
import '../../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../../utils/errorMessageKeys.dart';
import '../../../../utils/uiUtils.dart';
import '../../../widgets/circularProgressContainner.dart';
import '../../../widgets/errorContainer.dart';
import 'chatNewConversationList.dart'; 

class ChatNewAddScreen extends StatefulWidget {
 
  const ChatNewAddScreen({Key? key}) : super(key: key);

  @override
  State<ChatNewAddScreen> createState() => _ChatNewAddScreenState();
  static Route<dynamic> route(RouteSettings routeSettings) { 
      // Map arguments = routeSettings.arguments as Map;
      return CupertinoPageRoute(
         builder: (_) => BlocProvider<ChatUsersCubit>(
            create: (_) => ChatUsersCubit(ChatRepository()),
            child: ChatNewAddScreen()));
  }
}

class _ChatNewAddScreenState extends State<ChatNewAddScreen> with TickerProviderStateMixin {
 
 late Animation<double> containerGrowAnimation;
late AnimationController _screenController;
 late  AnimationController _buttonController;
 late  Animation<double> buttonGrowAnimation;
late Animation<double> listTileWidth;
 late  Animation<Alignment> listSlideAnimation;
late Animation<Alignment> buttonSwingAnimation;
 late  Animation<EdgeInsets> listSlidePosition;
late  Animation<Color?> fadeScreenAnimation;
    var animateStatus = 0;



  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero,() {
       context.read<ChatUsersCubit>().getAllChatUsersCub(
           userId: context.read<UserDetailsCubit>().getUserId(),
       );
     });
     _initGetData();
    _screenController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 1500), vsync: this);

    fadeScreenAnimation = new ColorTween(
      begin: const Color.fromRGBO(247, 64, 106, 1.0),
      end: const Color.fromRGBO(247, 64, 106, 0.0),
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: Curves.ease,
      ),
    );
    containerGrowAnimation = new CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeIn,
    );

    buttonGrowAnimation = new CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOut,
    );
    containerGrowAnimation.addListener(() {
      this.setState(() {});
    });
    containerGrowAnimation.addStatusListener((AnimationStatus status) {});

    listTileWidth = new Tween<double>(
      begin: 1000.0,
      end: 600.0,
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.225,
          0.600,
          curve: Curves.bounceIn,
        ),
      ),
    );

    listSlideAnimation = new AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.325,
          0.700,
          curve: Curves.ease,
        ),
      ),
    );
    buttonSwingAnimation = new AlignmentTween(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.225,
          0.600,
          curve: Curves.ease,
        ),
      ),
    );
    listSlidePosition = new EdgeInsetsTween(
      begin: const EdgeInsets.only(bottom: 50.0),
      end: const EdgeInsets.only(bottom: 0.0),
    )
        .animate(
      new CurvedAnimation(
        parent: _screenController,
        curve: new Interval(
          0.325,
          0.800,
          curve: Curves.ease,
        ),
      ),
    );
    _screenController.forward();
  }

  @override
  void dispose() {
    _screenController.dispose();
    _buttonController.dispose();
    super.dispose();
  }


/*   Future<Null> _playAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  } */

  _initGetData(){
     Future.delayed(Duration.zero,() {
       context.read<ChatUsersCubit>().getAllChatUsersCub(
           userId: context.read<UserDetailsCubit>().getUserId(),
       );
     });
  }

  @override
  Widget build(BuildContext context) {
    return //(new WillPopScope(
       // onWillPop: _onWillPop,
    
    Scaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        
        title: Text("Add a new chat", style: TextStyle(fontSize: 18),),
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
                child: Icon(
                  Icons.more_vert,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(0.0),
        child: _newChatBuild(context),
      ), 
    );
    //)),
  }
    Widget _newChatBuild(BuildContext context){
      return BlocConsumer<ChatUsersCubit, ChatUsersState>(
                    bloc: context.read<ChatUsersCubit>(), 
                    listener: (context, state){
                      if(state is ChatUsersFetchFailure){
                        if(state.errorMessage == unauthorizedAccessCode){
                          UiUtils.showAlreadyLoggedInDialog(context: context);
                        }
                      }
                    },
                    builder: (context, state){
                      if(state is ChatUsersFetchInProgress || state is ChatUsersInitial){
                        return Center(
                          child: CircularProgressContainer(useWhiteLoader: false),
                        );
                      }
                      if(state is ChatUsersFetchFailure){
                        return Center(
                          child: ErrorContainer(
                            showBackButton: false,
                            errorMessageColor: Theme.of(context).primaryColor,
                            errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                              convertErrorCodeToLanguageKey(state.errorMessage)
                            ),
                            onTapRetry: (){_initGetData();},
                            showErrorImage: true),
                        );
                      }

                      final chatUsersList = (state as ChatUsersFetchSuccess).chatUsersModelList;
                    
                      return SingleChildScrollView( 
                                          physics: BouncingScrollPhysics(),
                                            child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                   /*    SafeArea(
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
                                                      ), */


                                                    ListView.builder(
                                                            itemCount: chatUsersList.length,
                                                            shrinkWrap: true,
                                                            padding: EdgeInsets.only(top: 16),
                                                            physics: NeverScrollableScrollPhysics(),
                                                            itemBuilder: (context, index){
                                                              return ChatNewConversationList(
                                                                id: chatUsersList[index].id.toString(),
                                                                name: chatUsersList[index].name,
                                                                firebaseId: chatUsersList[index].firebaseId,
                                                                profileURL: chatUsersList[index].profileURL,
                                                                isPremier: chatUsersList[index].isPremier, 
                                                                mobile: chatUsersList[index].mobile,
                                                                senderIsPremier: context.read<UserDetailsCubit>().getUserIsPremium(),
                                                              listSlideAnimation: listSlideAnimation,
                                                              listSlidePosition: listSlidePosition,
                                                              listTileWidth: listTileWidth,
                                                              // isRead: (index == 0 || index == 3)?true:false,
                                                              );
                                                            },
                                                          ), 
                                            ],


                                            
                                          ),
                                          
                                        ); 
          },
          );
    }
  }