import 'dart:async';
 
import 'package:flutter/cupertino.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../../../app/routes.dart';
import '../../../features/mediaPlayers/MediaPlayerRepository.dart';
import '../../../features/mediaPlayers/cubits/MediaPlayerCubit.dart';
import '../../../features/mediaPlayers/models/MediaPlayerModel.dart'; 
import '../../../features/providers/BookmarksProvider.dart';
import '../../../features/providers/DownloadsProvider.dart';
import '../../../features/providers/SubscriptionProvider.dart'; 
import 'PlayingControls.dart';
import 'PositionSeekWidget.dart';
import 'SongsSelector.dart';
 

class AudioPlayerScreen extends StatefulWidget {
    static const routeName = "/audioPlayerScreen";
 
   final MediaPlayerModel media;
  final List<MediaPlayerModel> mediaList;
   const AudioPlayerScreen({Key? key, required this.media, required this.mediaList}) : super(key: key);  
  

 @override
 State<AudioPlayerScreen> createState() => _AudioPlayerScreenScreenState();
 static Route<dynamic> route(RouteSettings routeSettings){ 
        final arguments = routeSettings.arguments as Map<String, dynamic>?;
       return CupertinoPageRoute(
        builder: (_) => MultiProvider(
                providers: [BlocProvider<MediaPlayerCubit>(
                      create: (_) => MediaPlayerCubit(MediaPlayerRepository())),
                        
                         
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
               child: AudioPlayerScreen(
                media: arguments!['items'],
                mediaList: arguments['itemsList'],
        ),
            ));
  }
}

class _AudioPlayerScreenScreenState extends State<AudioPlayerScreen>{
  //late final AssetsAudioPlayer _assetsAudioPlayer;
  //final _assetsAudioPlayer = AssetsAudioPlayer();
 late AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  final List<StreamSubscription> _subscriptions = []; 
  late final audios; 
 

  @override
  void initState() {
    super.initState();

 
//will follow the AssetsAudioPlayer playing state

            
    
    //_assetsAudioPlayer = AssetsAudioPlayer();
    
    //_subscriptions.add(_assetsAudioPlayer.playlistFinished.listen((data) {
    //  print('finished : $data');
    //}));
    //openPlayer();
    _subscriptions.add(_assetsAudioPlayer.playlistAudioFinished.listen((data) {
      print('playlistAudioFinished : $data');
    }));
    _subscriptions.add(_assetsAudioPlayer.audioSessionId.listen((sessionId) {
      print('audioSessionId : $sessionId');
     
    }));
  

 audios = <Audio>[
     
    Audio.network(
      widget.media.streamUrl.toString(),
       metas: Metas(
        id:  widget.media.id.toString(),
        title:  widget.media.title.toString(),
        artist: widget.media.category.toString(),
        album: widget.media.category.toString(), 
        image: MetasImage.network(
          widget.media.coverPhoto.toString()),
       ),
    ), 
     
  ];
  
     
    openPlayer();
   // _assetsAudioPlayer.play();

  }



  

  void openPlayer() async {
    
    await _assetsAudioPlayer.open(
      Playlist(audios: audios, startIndex: 0),
      showNotification: true,
      autoStart: true,
    );
     //   _assetsAudioPlayer.playOrPause();

  }

  @override
  void dispose() {
   _assetsAudioPlayer.dispose();
   //_assetsAudioPlayer.pause();
     
    print('dispose');
    super.dispose();
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  Widget build(BuildContext context) {

 
     
      return Stack(
                children: <Widget>[ 
                Center(
                  child: Image.network( 
                      widget.media.coverPhoto.toString(),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitHeight,
                    ),
                ),  
            Container( 
              width: double.infinity,
              color: Color.fromARGB(47, 10, 0, 0),
             child:Scaffold(
          //backgroundColor: NeumorphicTheme.baseColor(context),
          // backgroundColor: primaryColor,
           backgroundColor: Color.fromARGB(55, 0, 0, 0),
            //  backgroundColor: Color.fromARGB(255, 82, 160, 114),
           appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(widget.media.title.toString()),
          ),
          body: SafeArea(
            child:Container(
                
              //child: Padding(
               // padding: const EdgeInsets.only(bottom: 2.0),
                child: Column(
                  
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                         children: <Widget>[

                                    SizedBox(
                                      height: 120,
                                    ),
                                      Stack(
                                      fit: StackFit.passthrough,
                                      children: <Widget>[
                                        StreamBuilder<Playing?>(
                                            stream: _assetsAudioPlayer.current,
                                            builder: (context, playing) {
                                              if (playing.connectionState == ConnectionState.waiting) {
                                                      return CircularProgressIndicator();
                                               }
                                              if (playing.data != null) {
                                                final myAudio = find(
                                                    audios, playing.data!.audio.assetAudioPath);  
                                                  /*     print(playing.data!.audio.assetAudioPath); 
                                             final isPlaying = widget.media.streamUrl.toString() == playing.data!.audio.assetAudioPath; */
                                                return Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Neumorphic(
                                                    style: NeumorphicStyle(
                                                      depth: 8,
                                                      surfaceIntensity: 1,
                                                      shape: NeumorphicShape.concave,
                                                      boxShape: NeumorphicBoxShape.circle(),
                                                    ),
                                                    child: myAudio.metas.image?.path == null
                                                        ? const SizedBox()
                                                        : myAudio.metas.image?.type ==
                                                                ImageType.network
                                                            ? Image.network(
                                                                myAudio.metas.image!.path,
                                                                height: 200,
                                                                width: 200,
                                                                fit: BoxFit.contain,
                                                              )
                                                            : Image.asset(
                                                                myAudio.metas.image!.path,
                                                                height: 200,
                                                                width: 200,
                                                                fit: BoxFit.contain,
                                                              ),
                                                  ),
                                                );
                                              }
                                              return SizedBox.shrink();
                                            }),
                                        
                                      ],
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ), 
                                    _assetsAudioPlayer.builderCurrent(
                                        builder: (context, Playing? playing) {
                                          
                                      return Column(
                                        children: <Widget>[
                                          _assetsAudioPlayer.builderLoopMode(
                                            builder: (context, loopMode) {
                                              return PlayerBuilder.isPlaying(
                                                  player: _assetsAudioPlayer,
                                                  builder: (context, isPlaying) {
                                                    return PlayingControls(
                                                      loopMode: loopMode,
                                                      isPlaying: isPlaying,
                                                      isPlaylist: true,
                                                      onStop: () {
                                                        _assetsAudioPlayer.stop();
                                                      },
                                                      toggleLoop: () {
                                                        _assetsAudioPlayer.toggleLoop();
                                                      },
                                                      onPlay: () {
                                                        _assetsAudioPlayer.playOrPause();
                                                      },
                                                      onNext: () {
                                                        //_assetsAudioPlayer.forward(Duration(seconds: 10));
                                                        _assetsAudioPlayer.next(
                                                            keepLoopMode:
                                                                true /*keepLoopMode: false*/);
                                                      },
                                                      onPrevious: () {
                                                        _assetsAudioPlayer.previous(
                                                            /*keepLoopMode: false*/);
                                                      },
                                                    );
                                                  });
                                            },
                                          ),
                                          _assetsAudioPlayer.builderRealtimePlayingInfos(
                                              builder: (context, RealtimePlayingInfos? infos) {
                                            if (infos == null) {
                                              return SizedBox();
                                            }
                                            //print('infos: $infos');
                                            return Column(
                                              children: [
                                                PositionSeekWidget(
                                                  currentPosition: infos.currentPosition,
                                                  duration: infos.duration,
                                                  seekTo: (to) {
                                                    _assetsAudioPlayer.seek(to);
                                                  },
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                        
                                                    NeumorphicButton(
                                                      onPressed: () {
                                                        _assetsAudioPlayer
                                                            .seekBy(Duration(seconds: -10));
                                                      },
                                                      child: Text('-10'),
                                                    ),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    NeumorphicButton(
                                                      onPressed: () {
                                                        _assetsAudioPlayer
                                                            .seekBy(Duration(seconds: 10));
                                                      },
                                                      child: Text('+10'),
                                                    ),
                                                    SizedBox(
                                                            width: 12,
                                                          ),
                                                    NeumorphicButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pushNamed(Routes.videoComments,
                                                                    arguments:
                                                                    {
                                                                      "item": widget.media,
                                                                      "commentCount": widget.media.commentsCount

                                                                    }   );
                                                          },
                                                          child: Text('Comments ('+widget.media.commentsCount.toString()+")" ),
                                                        ),
                                                          

                                                  ],
                                                ),

                                              //  Banneradmob(),
                                              ],
                                            );
                                          }),
                                        ],
                                      );
                                    }),
                                    
                         ]
                      )
                    ),
 

                    _assetsAudioPlayer.builderCurrent(
                        builder: (BuildContext context, Playing? playing) {
                      return SongsSelector(
                        audios: audios,
                        onPlaylistSelected: (myAudios) {
                          _assetsAudioPlayer.open(
                            Playlist(audios: myAudios),
                            showNotification: true,
                            headPhoneStrategy:
                                HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                            audioFocusStrategy: AudioFocusStrategy.request(
                                resumeAfterInterruption: true),
                          );
                        },
                        onSelected: (myAudio) async {
                          try {
                            await _assetsAudioPlayer.open(
                              myAudio,
                              autoStart: true,
                              showNotification: true,
                              playInBackground: PlayInBackground.enabled,
                              audioFocusStrategy: AudioFocusStrategy.request(
                                  resumeAfterInterruption: true,
                                  resumeOthersPlayersAfterDone: true),
                              headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
                              notificationSettings: NotificationSettings(
                                  //seekBarEnabled: false,
                                  //stopEnabled: true,
                                  //customStopAction: (player){
                                  //  player.stop();
                                  //}
                                  //prevEnabled: false,
                                  //customNextAction: (player) {
                                  //  print('next');
                                  //}
                                  //customStopIcon: AndroidResDrawable(name: 'ic_stop_custom'),
                                  //customPauseIcon: AndroidResDrawable(name:'ic_pause_custom'),
                                  //customPlayIcon: AndroidResDrawable(name:'ic_play_custom'),
                                  ),
                            );
                          } catch (e) {
                            print(e);
                          }
                        },
                        playing: playing,
                      );
                    }),
                    // 
                    /*
                    PlayerBuilder.volume(
                        player: _assetsAudioPlayer,
                        builder: (context, volume) {
                          return VolumeSelector(
                            volume: volume,
                            onChange: (v) {
                              _assetsAudioPlayer.setVolume(v);
                            },
                          );
                        }),
                     */
                    /*
                    PlayerBuilder.forwardRewindSpeed(
                        player: _assetsAudioPlayer,
                        builder: (context, speed) {
                          return ForwardRewindSelector(
                            speed: speed,
                            onChange: (v) {
                              _assetsAudioPlayer.forwardOrRewind(v);
                            },
                          );
                        }),
                     */
                    /*
                    PlayerBuilder.playSpeed(
                        player: _assetsAudioPlayer,
                        builder: (context, playSpeed) {
                          return PlaySpeedSelector(
                            playSpeed: playSpeed,
                            onChange: (v) {
                              _assetsAudioPlayer.setPlaySpeed(v);
                            },
                          );
                        }),
                     */
                  ],
                ),
                
              ),  
              
           // ),
          ),
        ),
      )
      ],
      );
    
  }
}