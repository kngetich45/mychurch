
import 'dart:async';
import 'dart:convert'; 
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:audiofileplayer/audio_system.dart';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/routes.dart';
import '../../i18n/strings.g.dart';
import '../../utils/Alerts.dart';
import '../../utils/Utility.dart';
import '../../utils/apiBodyParameterLabels.dart';
import '../../utils/apiUtils.dart';
import '../../utils/constants.dart'; 
import '../mediaPlayers/models/MediaPlayerModel.dart'; 
import '../profileManagement/cubits/userDetailsCubit.dart';
import '../profileManagement/models/userProfile.dart';

final Logger _logger = Logger('streamit_flutter');

class AudioPlayerProvider with ChangeNotifier {
  late BuildContext _context;
  List<MediaPlayerModel?> currentPlaylist = [];
  MediaPlayerModel? currentMedia;
  int currentMediaPosition = 0;
  Color backgroundColor = primaryColor;
  bool isDialogShowing = false;

   double backgroundAudioDurationSeconds = 0.0;
   double backgroundAudioPositionSeconds = 0.0;

   /// Background audio data for the fourth card.
  Audio? _backgroundAudio;
  bool _backgroundAudioPlaying = false;
  //double _backgroundAudioDurationSeconds = 0.0;
 // double _backgroundAudioPositionSeconds = 0.0;


  bool isSeeking = false;
  Audio? _remoteAudio;
  bool remoteAudioPlaying = false;
  bool _remoteAudioLoading = false;
  bool isUserSubscribed = false;
 // StreamController<double> controller = StreamController<double>();
  late StreamController<double> audioProgressStreams;
  bool isRadio = false;
  
int? commentsCount = 0;
  int? likesCount = 0;
  bool? isLiked = false; 
  UserProfile? userdata;
  
  /// Identifiers for the two custom Android notification buttons.
  static const String replayButtonId = 'replayButtonId';
  static const String newReleasesButtonId = 'newReleasesButtonId';
  static const String skipPreviousButtonId = 'skipPreviousButtonId';
  static const String skipNextButtonId = 'skipNextButtonId';

  AudioPlayerProvider() {
    getRepeatMode();
    AudioSystem.instance.addMediaEventListener(_mediaEventListener);
   audioProgressStreams = new StreamController<double>.broadcast();
    audioProgressStreams.add(0);
  }

  bool? _isRepeat = false;
  bool? get isRepeat => _isRepeat;
  changeRepeat() async {
    _isRepeat = !_isRepeat!;
   //notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("_isRepeatMode", _isRepeat!);
  }

  getRepeatMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("_isRepeatMode") != null) {
      _isRepeat = prefs.getBool("_isRepeatMode");
    }
  }

  setUserSubscribed(bool isUserSubscribed) {
    this.isUserSubscribed = isUserSubscribed;
  }
  setContext(BuildContext context) {
    _context = context;
  }

  setStreamController(double data) {
     audioProgressStreams = new StreamController<double>.broadcast();
    audioProgressStreams.add(data); 
  }

  bool _showList = false;
  bool get showList => _showList;
  setShowList(bool showList) {
    _showList = showList;
   //notifyListeners();
  }

  preparePlaylist(List<MediaPlayerModel?> playlist, MediaPlayerModel media) async {
    isRadio = false;
    currentPlaylist = playlist;
    startAudioPlayBack(media);
           
  }

  prepareradioplayer(MediaPlayerModel media) {
    isRadio = true;
    currentPlaylist = [];
    currentPlaylist.add(media);
    startAudioPlayBack(media);
  }

  startAudioPlayBack(MediaPlayerModel? media) {
    if (currentMedia != null) {
      _remoteAudio!.pause();
    } 
    currentMedia = media;
    setCurrentMediaPosition();
    _remoteAudioLoading = true;
    remoteAudioPlaying = false;
   //notifyListeners();
    audioProgressStreams.add(0);
    extractDominantImageColor(currentMedia!.coverPhoto);
    _remoteAudio = null;
    //_remoteAudio.dispose();
    if (isRadio) {
      _remoteAudio = Audio.loadFromRemoteUrl(media!.streamUrl!,
          onDuration: (double durationSeconds) {
            _remoteAudioLoading = false;
            remoteAudioPlaying = false;
             backgroundAudioDurationSeconds = durationSeconds;
            //////notifyListeners();
          },
          onPosition: (double positionSeconds) {
            print("positionSeconds = " + positionSeconds.toString());
            backgroundAudioPositionSeconds = positionSeconds;
            //if (isSeeking) return;
            audioProgressStreams.add(backgroundAudioPositionSeconds);

            if (Utility.isPreviewDuration(
                currentMedia, positionSeconds.round(), isUserSubscribed)) {
              _pauseBackgroundAudio();
              showPreviewSubscribeAlertDialog();
            }

            //TimUtil.parseDuration(event.parameters["progress"].toString());
          },
          //looping: _isRepeat,
          onComplete: () {
            if (_isRepeat!) {
              /*backgroundAudioPositionSeconds = 0;
            audioProgressStreams.add(backgroundAudioPositionSeconds);
            _pauseBackgroundAudio();
            _resumeBackgroundAudio();*/
              startAudioPlayBack(currentMedia);
            } else {
              skipNext();
            }
          },
          playInBackground: true,
          onError: (String? message) {
            /* _remoteAudio.dispose();
          _remoteAudio = null;
          remoteAudioPlaying = false;
          _remoteAudioLoading = false;*/
            cleanUpResources();
            Alerts.showCupertinoAlert(_context, t.error, message);
          });
    } else {
        _remoteAudio = Audio.loadFromRemoteUrl(media!.streamUrl!,
          onDuration: (double durationSeconds) {
            _remoteAudioLoading = false;
            remoteAudioPlaying = true;
          backgroundAudioDurationSeconds = durationSeconds;
           //notifyListeners();
          },
          onPosition: (double positionSeconds) {
            print("positionSeconds = " + positionSeconds.toString());
            backgroundAudioPositionSeconds = positionSeconds;
            //if (isSeeking) return;
            audioProgressStreams.add(backgroundAudioPositionSeconds);

            if (Utility.isPreviewDuration(
                currentMedia, positionSeconds.round(), isUserSubscribed)) {
              _pauseBackgroundAudio();
              showPreviewSubscribeAlertDialog();
            }

            //TimUtil.parseDuration(event.parameters["progress"].toString());
          },
          //looping: _isRepeat,
          onComplete: () {
            if (_isRepeat!) {
              /*backgroundAudioPositionSeconds = 0;
            audioProgressStreams.add(backgroundAudioPositionSeconds);
            _pauseBackgroundAudio();
            _resumeBackgroundAudio();*/
              startAudioPlayBack(currentMedia);
            } else {
              skipNext();
            }
          },
          playInBackground: true,
          onError: (String? message) {
            /* _remoteAudio.dispose();
          _remoteAudio = null;
          remoteAudioPlaying = false;
          _remoteAudioLoading = false;*/
            cleanUpResources();
            Alerts.showCupertinoAlert(_context, t.error, message);
          })!
        ..play();
    }

    remoteAudioPlaying = false;
    setMediaNotificationData(0);
  }

  showPreviewSubscribeAlertDialog() {
    if (isDialogShowing) return;
    isDialogShowing = true;
    return showDialog(
      context: _context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.subscribehint),
          content: Text(t.previewsubscriptionrequiredhint),
          actions: <Widget>[
            TextButton(
              child: Text(t.cancel.toUpperCase()),
              onPressed: () {
                Navigator.of(context).pop();
                isDialogShowing = false;
              },
            ),
            TextButton(
              child: Text(t.subscribe),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(Routes.subscription);
                isDialogShowing = false;
              },
            )
          ],
        );
      },
    );
  }

  setCurrentMediaPosition() {
    currentMediaPosition = currentPlaylist.indexOf(currentMedia);
    if (currentMediaPosition == -1) {
      currentMediaPosition = 0;
    }
    print("currentMediaPosition = " + currentMediaPosition.toString());
  }

  cleanUpResources() {
    _stopBackgroundAudio();
  }

  Widget icon() {
    if (_remoteAudioLoading) {
      return Theme(
          data: ThemeData(
              cupertinoOverrideTheme:
                  CupertinoThemeData(brightness: Brightness.dark)),
          child: CupertinoActivityIndicator());
    }
    if (remoteAudioPlaying) {
      return const Icon(
        Icons.pause,
        size: 40,
        color: Colors.white,
      );
    }
    return const Icon(
      Icons.play_arrow,
      size: 40,
      color: Colors.white,
    );
  }

  onPressed() {
    return remoteAudioPlaying
        ? _pauseBackgroundAudio()
        : _resumeBackgroundAudio();
  }

  void _mediaEventListener(MediaEvent mediaEvent) {
    _logger.info('App received media event of type: ${mediaEvent.type}');
    final MediaActionType type = mediaEvent.type;
    if (type == MediaActionType.play) {
      _resumeBackgroundAudio();
    } else if (type == MediaActionType.pause) {
      _pauseBackgroundAudio();
    } else if (type == MediaActionType.playPause) {
      _backgroundAudioPlaying ? _pauseBackgroundAudio() : _resumeBackgroundAudio();
    } else if (type == MediaActionType.stop) {
      _stopBackgroundAudio();
    } else if (type == MediaActionType.seekTo) {
      _backgroundAudio!.seek(mediaEvent.seekToPositionSeconds!);
    //  _remoteAudio!.seek(mediaEvent.seekToPositionSeconds!);
      AudioSystem.instance
          .setPlaybackState(true, mediaEvent.seekToPositionSeconds!);
    } else if (type == MediaActionType.next) {
      print("skip next");
      skipNext();
      final double? skipIntervalSeconds = mediaEvent.skipIntervalSeconds;
      _logger.info(
          'Skip-forward event had skipIntervalSeconds $skipIntervalSeconds.');
      _logger.info('Skip-forward is not implemented in this example app.');
    } else if (type == MediaActionType.previous) {
      print("skip next");
      skipPrevious();
      final double? skipIntervalSeconds = mediaEvent.skipIntervalSeconds;
      _logger.info(
          'Skip-backward event had skipIntervalSeconds $skipIntervalSeconds.');
      _logger.info('Skip-backward is not implemented in this example app.');
    } else if (type == MediaActionType.custom) {
      if (mediaEvent.customEventId == replayButtonId) {
        _backgroundAudio!.play();
        AudioSystem.instance.setPlaybackState(true, 0.0);
      } else if (mediaEvent.customEventId == newReleasesButtonId) {
        _logger
            .info('New-releases button is not implemented in this exampe app.');
      }
    }
  }

  Future<void> _resumeBackgroundAudio() async {
    _backgroundAudio!.resume();
    //remoteAudioPlaying = true;
    // setState(() => _backgroundAudioPlaying = true);
   //notifyListeners();
    setMediaNotificationData(0);
  }

  void _pauseBackgroundAudio() {
    _remoteAudio!.pause();
    remoteAudioPlaying = false;
   //notifyListeners();
    setMediaNotificationData(1);
  }

  void _stopBackgroundAudio() {
    _backgroundAudio!.pause();
    currentMedia = null;
   //notifyListeners();
    // setState(() => _backgroundAudioPlaying = false);
    AudioSystem.instance.stopBackgroundDisplay();
  }

  void shufflePlaylist() {
    currentPlaylist.shuffle();
    startAudioPlayBack(currentPlaylist[0]);
  }

  skipPrevious() {
    if (currentPlaylist.length == 0 || currentPlaylist.length == 1) return;
    int pos = currentMediaPosition - 1;
    if (pos == -1) {
      pos = currentPlaylist.length - 1;
    }
    MediaPlayerModel? media = currentPlaylist[pos];
    if (Utility.isMediaRequireUserSubscription(media, isUserSubscribed)) {
      Alerts.showPlaySubscribeAlertDialog(_context);
      return;
    } else {
      startAudioPlayBack(media);
    }
  }

  skipNext() {
    if (currentPlaylist.length == 0 || currentPlaylist.length == 1) return;
    int pos = currentMediaPosition + 1;
    if (pos >= currentPlaylist.length) {
      pos = 0;
    }
    MediaPlayerModel? media = currentPlaylist[pos];
    if (Utility.isMediaRequireUserSubscription(media, isUserSubscribed)) {
      Alerts.showPlaySubscribeAlertDialog(_context);
      return;
    } else {
      startAudioPlayBack(media);
    }
  }

  seekTo(double positionSeconds) {
    //audioProgressStreams.add(_backgroundAudioPositionSeconds);
    //_remoteAudio.seek(positionSeconds);
    //isSeeking = false;
    backgroundAudioPositionSeconds = positionSeconds;
    _remoteAudio!.seek(positionSeconds);
    audioProgressStreams.add(backgroundAudioPositionSeconds);
    AudioSystem.instance.setPlaybackState(true, positionSeconds);
  }

  onStartSeek() {
    isSeeking = true;
  }

  /// Generates a 200x200 png, with randomized colors, to use as art for the
  /// notification/lockscreen.
  static Future<Uint8List> generateImageBytes(String coverphoto) async {
    /*Uint8List byteImage = await networkImageToByte(coverphoto);
    return byteImage;*/

    Uint8List bytes =
        (await NetworkAssetBundle(Uri.parse(coverphoto)).load(coverphoto))
            .buffer
            .asUint8List();
    return bytes;
  }

  setMediaNotificationData(int state) async {
    // final Uint8List imageBytes =
    //   await generateImageBytes(currentMedia.cover_photo);

    if (state == 0) {
      
      AudioSystem.instance
          .setPlaybackState(true, backgroundAudioPositionSeconds);
      AudioSystem.instance.setAndroidNotificationButtons(<dynamic>[
        AndroidMediaButtonType.pause,
        AndroidMediaButtonType.previous,
        AndroidMediaButtonType.next,
        AndroidMediaButtonType.stop,
        const AndroidCustomMediaButton(
            'replay', replayButtonId, 'ic_replay_black_36dp')
      ], androidCompactIndices: <int>[
        0
      ]);
    } else {
      AudioSystem.instance
          .setPlaybackState(false, backgroundAudioPositionSeconds);
      AudioSystem.instance.setAndroidNotificationButtons(<dynamic>[
        AndroidMediaButtonType.play,
        AndroidMediaButtonType.previous,
        AndroidMediaButtonType.next,
        AndroidMediaButtonType.stop,
        const AndroidCustomMediaButton(
            'replay', replayButtonId, 'ic_replay_black_36dp')
      ], androidCompactIndices: <int>[
        0
      ]);
    }

    AudioSystem.instance.setMetadata(AudioMetadata(
        title: currentMedia!.title,
        artist: currentMedia!.category,
        album: currentMedia!.category,
        genre: currentMedia!.category,
        durationSeconds: backgroundAudioDurationSeconds,
        artBytes: await generateImageBytes(currentMedia!.coverPhoto!)));

    AudioSystem.instance.setSupportedMediaActions(<MediaActionType>{
      MediaActionType.playPause,
      MediaActionType.pause,
      MediaActionType.next,
      MediaActionType.previous,
      MediaActionType.skipForward,
      MediaActionType.skipBackward,
      MediaActionType.seekTo,
    }, skipIntervalSeconds: 30);
  }

  extractDominantImageColor(String? url) async {
    if (url == "" || isRadio) {
      backgroundColor = primaryColor;
     //notifyListeners();
    } else {
      PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        NetworkImage(url!),
      );
      if (paletteGenerator.dominantColor != null) {
        backgroundColor = paletteGenerator.dominantColor!.color;
       //notifyListeners();
      } else {
        backgroundColor = primaryColor;
       //notifyListeners();
      }
    }
  }





  setMediaLikesCommentsCount(MediaPlayerModel media) {
    currentMedia = media;
    print("currentmedia = " + currentMedia!.id.toString());
    commentsCount = media.commentsCount;
    likesCount = media.likesCount;
    isLiked = media.userLiked == null ? false : media.userLiked;
    //notifyListeners();
    updateViewsCount();
    getMediaLikesCommentsCount();
  }

  Future<void> getMediaLikesCommentsCount() async {
   //try {

       /* _context.read<MediaPlayerCubit>().getMediaLikesCommentsCount(  
          mediaId: currentMedia!.id,
          userId: _context.read<UserDetailsCubit>().getUserId(),
          userEmail: _context.read<UserDetailsCubit>().getUserEmail(),
        ); */

  try {
      //body of post request
     /*  final body = {
        accessValueKey: accessValue, 
        userIdKey: _context.read<UserDetailsCubit>().getUserId(),
        userEmailKey: _context.read<UserDetailsCubit>().getUserEmail(),
        mediaId: currentMedia!.id,
        
      }; 
      final response = await http.post(Uri.parse(getmedia),
          body: body, headers: await ApiUtils.getHeaders());
      final responseJson = jsonDecode(response.body);
      if (responseJson['error']) { 
        throw MediaPlayerException(errorMessageCode: responseJson['message']);
      }  
      print(responseJson['data']);
      return responseJson['data'];
    } on SocketException catch (_) {
      throw MediaPlayerException(errorMessageCode: noInternetCode);
    } on MediaPlayerException catch (e) {
      throw MediaPlayerException(errorMessageCode: e.toString());
    } catch (e) {
      throw MediaPlayerException(errorMessageCode: defaultErrorMessageCode);
    } */
 

 
      final data = {
         accessValueKey: accessValue, 
        userIdKey: _context.read<UserDetailsCubit>().getUserId(),
        userEmailKey: _context.read<UserDetailsCubit>().getUserEmail(),
        mediaId: currentMedia!.id,
      };
      print("get_media_count = " + data.toString());
      final response = await http.post(
          Uri.parse(getmediatotallikesandcommentsviews),
          //body: jsonEncode({"data": data}));
           body: data, headers: await ApiUtils.getHeaders());
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        Map<String, dynamic> res = json.decode(response.body);
        commentsCount = int.parse(res['total_comments'].toString());
        likesCount = int.parse(res['total_likes'].toString());
         likesCount = int.parse(res['total_likes'].toString());
        isLiked = res['isLiked'] == null ? false : res['isLiked'] as bool?;
        notifyListeners();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }  
  }

  Future<void> updateViewsCount() async {
   // var data = {"media": currentMedia!.id};
     final data = {
         accessValueKey: accessValue, 
        userIdKey: _context.read<UserDetailsCubit>().getUserId(),
        userEmailKey: _context.read<UserDetailsCubit>().getUserEmail(),
        mediaId: currentMedia!.id,
      };
    print(data.toString());
    try {
      final response = await http.post(
          Uri.parse(updateMediaTotalViews),
          //body: jsonEncode({"data": data}));
           body: data, headers: await ApiUtils.getHeaders());
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  Future<void> likePost(String action) async {
    if (userdata == null) {
      return;
    }
    if (action == "like") {
      likesCount = likesCount! + 1;
      isLiked = true;
      notifyListeners();
    } else {
      likesCount = likesCount! - 1;
      isLiked = false;
      notifyListeners();
    }
    /* var data = {
      "media": currentMedia!.id,
      "email": userdata!.email,
      "action": action
    }; */
    final data = {
         accessValueKey: accessValue, 
        userIdKey: _context.read<UserDetailsCubit>().getUserId(),
        userEmailKey: _context.read<UserDetailsCubit>().getUserEmail(),
        mediaId: currentMedia!.id,
        action: action
      };

    print(data.toString());
    try {
      final response = await http.post(Uri.parse(likeunlikemedia),
        //  body: jsonEncode({"data": data}));
           body: data, headers: await ApiUtils.getHeaders());
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  navigatetoCommentsScreen(BuildContext context) async {
    var count = await  Navigator.of(context).pushNamed(Routes.comments, arguments: { 
                  "mediaItem":currentMedia,
                  "commentCount": commentsCount
              }); 
    
    /* 
    Navigator.of(context).pushNamed(arguments :{
      "item"=currentMedia,
       "commentCount"= commentsCount

    }
      )
    )
    
     Navigator.pushNamed(
      context,
      CommentsScreen.routeName,
      arguments:
          CommentsArguement(item: currentMedia, commentCount: commentsCount),
    ); */
    commentsCount = count as int?;
    notifyListeners();
  }
}
 
