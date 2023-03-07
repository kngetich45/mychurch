 
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../features/profileManagement/models/userProfile.dart';
import '../../../features/providers/AudioPlayerProvider.dart';
import '../../../i18n/strings.g.dart';
import '../../styles/TextStyles.dart';
import '../../widgets/Banneradmob.dart';
import '../../widgets/MarqueeWidget.dart';
import 'player_anim.dart'; 
import 'package:provider/provider.dart'; 
import 'radio_carousel.dart';

class RadioPlayer extends StatefulWidget {
  static const routeName = "/radioplayer";
  RadioPlayer();

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<RadioPlayer> with TickerProviderStateMixin {
  AnimationController? controllerPlayer;
  late Animation<double> animationPlayer;
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  UserProfile? userdata;

  @override
  initState() {
    super.initState();
    userdata = context.read<UserDetailsCubit>().getUserProfile(); 
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
  }

  @override
  void dispose() {
    controllerPlayer!.dispose();
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    var mediaQuery = MediaQuery.of(context);
    AudioPlayerProvider radioPlayerModel = Provider.of(context);
    if (radioPlayerModel.remoteAudioPlaying) {
      controllerPlayer!.forward();
    } else {
      controllerPlayer!.stop(canceled: false);
    }
    if (radioPlayerModel.currentMedia == null) {
      Navigator.of(context).pop();
    }
    return radioPlayerModel.currentMedia == null
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
        : Scaffold(
            body: Stack(
              children: <Widget>[
                _buildWidgetAlbumCoverBlur(mediaQuery, radioPlayerModel),
                BuildPlayerBody(
                    userdata: userdata,
                    radioPlayerModel: radioPlayerModel,
                    commonTween: _commonTween,
                    controllerPlayer: controllerPlayer),
              ],
            ),
          );
  }

  Widget _buildWidgetAlbumCoverBlur(
      MediaQueryData mediaQuery, AudioPlayerProvider radioPlayerModel) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage(radioPlayerModel.currentMedia!.coverPhoto!),
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
    required this.radioPlayerModel,
    required Tween<double> commonTween,
    required this.controllerPlayer,
    required this.userdata,
  })  : _commonTween = commonTween,
        super(key: key);

  final AudioPlayerProvider radioPlayerModel;
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
                            radioPlayerModel.currentMedia!.title!,
                            maxLines: 1,
                            style: TextStyles.subhead(context)
                                .copyWith(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    RotatePlayer(
                        coverPhoto: radioPlayerModel.currentMedia!.coverPhoto,
                        animation: _commonTween.animate(controllerPlayer!)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  ],
                ),
              ],
            ),
          ),
          RadioCarousal(),
          Banneradmob(),
        ],
      ),
    );
  }
}
