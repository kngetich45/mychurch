import 'package:bevicschurch/features/profileManagement/cubits/userDetailsCubit.dart';
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../app/routes.dart';
import '../../../features/comments/CommentsRepository.dart';
import '../../../features/comments/cubits/CommentsCubit.dart';
import '../../../features/comments/models/CommentsModel.dart';
import '../../../features/mediaPlayers/MediaPlayerRepository.dart';
import '../../../features/mediaPlayers/cubits/MediaPlayerCubit.dart';
import '../../../features/models/Replies.dart';
import '../../../features/profileManagement/models/userProfile.dart';
import '../../../features/providers/RepliesModel.dart';
import '../../../i18n/strings.g.dart';
import '../../widgets/RepliesItem.dart';  

class RepliesScreen extends StatefulWidget {
  static String routeName = "/replies";
  final Object? item;
  final int? repliesCount;

  RepliesScreen({Key? key, this.item, this.repliesCount}) : super(key: key);

  @override
  _RepliesScreenState createState() => _RepliesScreenState();
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
               child: RepliesScreen(
                item: arguments!['item'],
               repliesCount: arguments['repliesCount'],
        ),
            ));
  } 
}

class _RepliesScreenState extends State<RepliesScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.item.toString());
    final appState = context.read<UserDetailsCubit>().getUserProfile();
    UserProfile? userdata = appState;

    return ChangeNotifierProvider(
        create: (context) => RepliesModel(context, (widget.item as CommentsModel).id,
            userdata, widget.repliesCount),
        child: RepliesSection(widget: widget, userdata: userdata));
  }
}

class RepliesSection extends StatelessWidget {
  const RepliesSection({
    Key? key,
    required this.widget,
    required this.userdata,
  }) : super(key: key);

  final RepliesScreen widget;
  final UserProfile? userdata;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
            context,
            Provider.of<RepliesModel>(context, listen: false)
                .totalCommentsReply);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.pop(
                context,
                Provider.of<RepliesModel>(context, listen: false)
                    .totalCommentsReply),
          ),
          title: Text(t.replies),
        ),
        body: Column(
          children: <Widget>[
            Container(height: 3),
            Expanded(
              child: RepliesLists(),
            ),
            Divider(height: 0, thickness: 1),
            userdata == null
                ? Container(
                    height: 50,
                    child: Center(
                        child: ElevatedButton(
                            child: Text(t.logintoreply),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(Routes.login); 
                            })),
                  )
                : Consumer<RepliesModel>(
                    builder: (context, commentsModel, child) {
                    return Row(
                      children: <Widget>[
                        Container(width: 10),
                        Expanded(
                          child: TextField(
                            controller: commentsModel.inputController,
                            maxLines: 5,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            decoration: new InputDecoration.collapsed(
                                hintText: t.writeamessage),
                          ),
                        ),
                        commentsModel.isMakingComment
                            ? Container(
                                width: 30, child: CupertinoActivityIndicator())
                            : IconButton(
                                icon: Icon(Icons.send,
                                    color: primaryColor, size: 20),
                                onPressed: () {
                                  String text =
                                      commentsModel.inputController.text;
                                  if (text != "") {
                                    commentsModel.makeComment(text);
                                  }
                                }),
                      ],
                    );
                  })
          ],
        ),
      ),
    );
  }
}

class RepliesLists extends StatelessWidget {
  const RepliesLists({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var repliesModel = Provider.of<RepliesModel>(context);
    List<Replies> repliesList = repliesModel.items;
    if (repliesModel.isLoading) {
      return Center(child: CupertinoActivityIndicator());
    } else if (repliesList.length == 0) {
      return Center(
          child: Container(
        height: 200,
        child: GestureDetector(
          onTap: () {
            repliesModel.loadComments();
          },
          child: ListView(children: <Widget>[
            Icon(
              Icons.refresh,
              size: 50.0,
              color: Colors.red,
            ),
            Text(
              t.nocomments,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            )
          ]),
        ),
      ));
    } else {
      return ListView.separated(
        controller: repliesModel.scrollController,
        itemCount: repliesModel.hasMoreComments!
            ? repliesList.length + 1
            : repliesList.length,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          if (index == 0 && repliesModel.isLoadingMore) {
            return Container(
                width: 30, child: Center(child: CupertinoActivityIndicator()));
          } else if (index == 0 && repliesModel.hasMoreComments!) {
            return Container(
              height: 30,
              child: Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20)),
                      ),
                      child: Text(t.loadmore),
                      onPressed: () {
                        Provider.of<RepliesModel>(context, listen: false)
                            .loadMoreComments();
                      })),
            );
          } else {
            int _index = index;
            if (repliesModel.hasMoreComments!) _index = index - 1;
            return RepliesItem(
              isUser: repliesModel.isUser(repliesList[_index].email),
              context: context,
              index: _index,
              object: repliesList[_index],
            );
          }
        },
      );
    }
  }
}
