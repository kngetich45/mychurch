 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import '../../../features/mediaPlayers/MediaPlayerRepository.dart';
import '../../../features/mediaPlayers/cubits/MediaPlayerCubit.dart';
import '../../../features/mediaPlayers/models/MediaPlayerModel.dart';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../features/profileManagement/models/userProfile.dart';
import '../../../features/providers/AudioPlayerProvider.dart';
import '../../../features/providers/BookmarksProvider.dart';
import '../../../features/providers/DownloadsProvider.dart';
import '../../../features/providers/MediaPlayerProvider.dart';
import '../../../features/providers/SubscriptionProvider.dart';
import '../../../i18n/strings.g.dart'; 
import '../../styles/TextStyles.dart';
import '../../widgets/Banneradmob.dart';
import '../../widgets/MarqueeWidget.dart';
import '../../widgets/MediaPopupMenu.dart';
import 'player_anim.dart'; 
import 'song_list_carousel.dart';
import 'package:provider/provider.dart';
import 'player_carousel.dart'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayPage extends StatefulWidget {
  static const routeName = "/playerpage";
 
   final MediaPlayerModel media;
  final List<MediaPlayerModel> mediaList;
   const PlayPage({Key? key, required this.media, required this.mediaList}) : super(key: key);  
  
 //const PlayPage({Key? key}) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
 static Route<dynamic> route(RouteSettings routeSettings){ 
        final arguments = routeSettings.arguments as Map<String, dynamic>?;
       return CupertinoPageRoute(
        builder: (_) => MultiProvider(
                providers: [BlocProvider<MediaPlayerCubit>(
                      create: (_) => MediaPlayerCubit(MediaPlayerRepository())),
                        
                        ChangeNotifierProvider<AudioPlayerProvider>(
                          create: (_) => AudioPlayerProvider(),
                        ), 
                        ChangeNotifierProvider<BookmarksProvider>(
                          create: (_) => BookmarksProvider(),
                        ),
                        ChangeNotifierProvider<DownloadsProvider>(
                          create: (_) => DownloadsProvider(),
                        ),
                        ChangeNotifierProvider<SubscriptionProvider>(
                          create: (_) => SubscriptionProvider(),
                        ),
                     // ChangeNotifierProvider.value(value: BibleProvider()),
                      ],
               child: PlayPage(
                media: arguments!['items'],
                mediaList: arguments['itemsList'],
        ),
            ));
  } 

}

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {
  AnimationController? controllerPlayer;
  late Animation<double> animationPlayer;
  MediaPlayerModel? currentMedia;

  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  UserProfile? userdata;

  @override
  initState() {
    super.initState();
    userdata = context.read<UserDetailsCubit>().getUserProfile(); 

      currentMedia = widget.media;
    controllerPlayer = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationPlayer =
        new CurvedAnimation(parent: controllerPlayer!, curve: Curves.linear);
    animationPlayer.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerPlayer!.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controllerPlayer!.forward();
      }
    });
 
      Provider.of<AudioPlayerProvider>(context, listen: false).preparePlaylist(widget.mediaList,widget.media);  
 
 

  }

  @override
  void dispose() {
    controllerPlayer!.dispose();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode([SystemUiOverlay.bottom]);
   Provider.of<AudioPlayerProvider>(context, listen: false).setContext(context);
    AudioPlayerProvider audioPlayerModel = Provider.of<AudioPlayerProvider>(context);
    var mediaQuery = MediaQuery.of(context);
    //AudioPlayerProvider audioPlayerModel = Provider.of(context);
      
    if (audioPlayerModel.remoteAudioPlaying) {
      controllerPlayer!.forward();
    } else {
      controllerPlayer!.stop(canceled: false);
    }
    // ignore: unnecessary_null_comparison
    if (widget.media == null) {
       
      Navigator.of(context).pop();
    }
    // ignore: unnecessary_null_comparison
    return widget.media == null
        ? Container(
            color: Colors.black,
            child: Center(
              child: Text(
                t.cleanupresources,
                style: TextStyles.headline(context)
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          )
        : ChangeNotifierProvider(
            create: (context) =>
                MediaPlayerProvider(userdata, widget.media),
            child: Scaffold(
              body: Stack(
                children: <Widget>[
                  _buildWidgetAlbumCoverBlur(mediaQuery, audioPlayerModel),
                  BuildPlayerBody(
                      userdata: userdata,
                      audioPlayerModel: audioPlayerModel,
                      commonTween: _commonTween,
                      controllerPlayer: controllerPlayer),
                ],
              ),
            ),
          );
  }

  Widget _buildWidgetAlbumCoverBlur(
      MediaQueryData mediaQuery, AudioPlayerProvider audioPlayerModel) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage(audioPlayerModel.currentMedia!.coverPhoto!),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.0),
          ),
        ),
      ),
    );
  }
}

class BuildPlayerBody extends StatelessWidget {
  const BuildPlayerBody({
    Key? key,
    required this.audioPlayerModel,
    required Tween<double> commonTween,
    required this.controllerPlayer,
    required this.userdata,
  })  : _commonTween = commonTween,
        super(key: key);

  final AudioPlayerProvider audioPlayerModel;
  final Tween<double> _commonTween;
  final AnimationController? controllerPlayer;
  final UserProfile? userdata;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 25.0,
                        color: Colors.white,
                      ),
                      onPressed: () => {
                        Navigator.pop(context),
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: MarqueeWidget(
                          direction: Axis.horizontal,
                          child: Text(
                            audioPlayerModel.currentMedia!.title!,
                            maxLines: 1,
                            style: TextStyles.subhead(context)
                                .copyWith(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                !audioPlayerModel.showList
                    ? Column(
                        children: <Widget>[
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                          RotatePlayer(
                              coverPhoto:
                                  audioPlayerModel.currentMedia!.coverPhoto,
                              animation:
                                  _commonTween.animate(controllerPlayer!)),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                        ],
                      )
                    : SongListCarousel(),
              ],
            ),
          ),
          Player(),
          MediaCommentsLikesContainer(
              key: UniqueKey(),
              context: context,
              audioPlayerModel: audioPlayerModel,
              currentMedia: audioPlayerModel.currentMedia),
          Banneradmob(),
        ],
      ),
    );
  }
}

class MediaCommentsLikesContainer extends StatefulWidget {
  const MediaCommentsLikesContainer({
    Key? key,
    required this.context,
    required this.currentMedia,
    required this.audioPlayerModel,
  }) : super(key: key);

  final BuildContext context;
  final MediaPlayerModel? currentMedia;
  final AudioPlayerProvider audioPlayerModel;

  @override
  _MediaCommentsLikesContainerState createState() =>
      _MediaCommentsLikesContainerState();
}

class _MediaCommentsLikesContainerState  extends State<MediaCommentsLikesContainer> {
  @override
  Widget build(BuildContext context) {
    
    return Consumer<AudioPlayerProvider>(
      builder: (context, aPlayerModel, child) {
          
        return Container(
          height: 50,
          margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                onTap: () {
                  aPlayerModel
                      .likePost(aPlayerModel.isLiked! ? "unlike" : "like");
                },
                child: Row(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                    child: FaIcon(FontAwesomeIcons.thumbsUp,
                        size: 26,
                        color: aPlayerModel.isLiked!
                            ? Colors.pink
                            : Colors.white),
                  ),
                  aPlayerModel.likesCount == 0
                      ? Container()
                      : Text(aPlayerModel.likesCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                ]),
              ),
              InkWell(
                onTap: () {
                  aPlayerModel.navigatetoCommentsScreen(context);
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.insert_comment, size: 26, color: Colors.white),
                    aPlayerModel.commentsCount == 0
                        ? Container()
                        : Text(aPlayerModel.commentsCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.audioPlayerModel.shufflePlaylist();
                  Provider.of<MediaPlayerProvider>(context, listen: false)
                      .setMediaLikesCommentsCount(
                          widget.audioPlayerModel.currentMedia!,context.read<UserDetailsCubit>().getUserId());
                },
                icon: Icon(
                  Icons.shuffle,
                  size: 26.0,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => widget.audioPlayerModel
                    .setShowList(!widget.audioPlayerModel.showList),
                icon: Icon(
                  Icons.playlist_play,
                  size: 27.0,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () => widget.audioPlayerModel.changeRepeat(),
                icon: widget.audioPlayerModel.isRepeat == true
                    ? Icon(
                        Icons.repeat_one,
                        size: 26.0,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.repeat,
                        size: 26.0,
                        color: Colors.white,
                      ),
              ),
              MediaPopupMenu(widget.currentMedia),
            ],
          ),
        );
      },
    );
  }
}
