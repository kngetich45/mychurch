import 'package:bevicschurch/features/providers/AudioPlayerProvider.dart';
import 'package:bevicschurch/features/providers/SubscriptionProvider.dart';
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../features/mediaPlayers/MediaPlayerRepository.dart';
import '../../../features/mediaPlayers/cubits/MediaPlayerCubit.dart';
import '../../../features/mediaPlayers/models/MediaPlayerModel.dart';
import '../../styles/TextStyles.dart';
import '../../widgets/MarqueeWidget.dart';
import 'player_page.dart';  

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override 
  State<MiniPlayer> createState() => _AudioPlayout();
   static Route<dynamic> route(RouteSettings routeSettings){
     // Map arguments = routeSettings.arguments as Map; 
     
       return CupertinoPageRoute(
        builder: (_) => MultiProvider(
                providers: [BlocProvider<MediaPlayerCubit>(
                      create: (_) => MediaPlayerCubit(MediaPlayerRepository())), 
                       ChangeNotifierProvider<AudioPlayerProvider>(
                          create: (_) => AudioPlayerProvider(),
                        ),
                        ChangeNotifierProvider<SubscriptionProvider>(
                          create: (_) => SubscriptionProvider(),
                        ), 
                         
                     // ChangeNotifierProvider.value(value: BibleProvider()),
                      ],
              child: MiniPlayer(),
            ));
  }

}

class _AudioPlayout extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    bool isSubscribed = Provider.of<SubscriptionProvider>(context).isSubscribed;
    Provider.of<AudioPlayerProvider>(context, listen: false).setUserSubscribed(isSubscribed);
    Provider.of<AudioPlayerProvider>(context, listen: false).setContext(context);
    //Provider.of<AudioPlayerProvider>(context, listen: false).setStreamController(0);
    return Consumer<AudioPlayerProvider>(
      builder: (context, audioPlayerModel, child) {
        MediaPlayerModel? mediaItem = audioPlayerModel.currentMedia;
        return mediaItem == null
            ? Container()
            : GestureDetector(
                onTap: () {
                  if (!audioPlayerModel.isRadio) {
                    Navigator.of(context).pushNamed(PlayPage.routeName);
                  }
                },
                child: Container(
                  height: 65,
                  //color: Colors.grey[900],
                  child: Card(
                      color: audioPlayerModel.backgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      margin: EdgeInsets.all(0),
                      elevation: 10,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            // ignore: unnecessary_null_comparison
                            mediaItem == null
                                ? Container()
                                : (mediaItem.coverPhoto == ""
                                    ? Icon(Icons.audiotrack)
                                    : Container(
                                        height: 50,
                                        width: 50,
                                        child: Image(
                                          image: NetworkImage(
                                              mediaItem.coverPhoto!),
                                        ),
                                      )),
                            Container(
                              width: 12,
                            ),
                            Expanded(
                              child: MarqueeWidget(
                                direction: Axis.horizontal,
                                child: Text(
                                  // ignore: unnecessary_null_comparison
                                  mediaItem != null ? mediaItem.title! : "",
                                  maxLines: 1,
                                  style: TextStyles.subhead(context).copyWith(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            ),
                            !audioPlayerModel.isRadio
                                ? IconButton(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    onPressed: () {
                                      audioPlayerModel.skipPrevious();
                                    },
                                    icon: const Icon(
                                      Icons.skip_previous,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  )
                                : Container(
                                    width: 15,
                                  ),
                            ClipOval(
                                child: Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withAlpha(30),
                              width: 50.0,
                              height: 50.0,
                              child: IconButton(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                onPressed: () {
                                  audioPlayerModel.onPressed();
                                },
                                icon: audioPlayerModel.icon(),
                              ),
                            )),
                            !audioPlayerModel.isRadio
                                ? IconButton(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    onPressed: () {
                                      audioPlayerModel.skipNext();
                                    },
                                    icon: const Icon(
                                      Icons.skip_next,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  )
                                : Container(
                                    width: 15,
                                  ),
                            Container(
                              color: primaryColor,
                              //width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              );
      },
    );
  }
}
