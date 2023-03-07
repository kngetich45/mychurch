import 'package:bevicschurch/features/providers/MediaPlayerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../features/providers/AudioPlayerProvider.dart';
import '../../../utils/TimUtil.dart'; 

class Player extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AudioPlayerProvider audioPlayerModel = Provider.of<AudioPlayerProvider>(context);
    
    return Column(
      children: _controllers(context, audioPlayerModel),
    );
  }

  Widget _timer(BuildContext context, AudioPlayerProvider audioPlayerModel) {
    var style = new TextStyle(
      color: Colors.white,
      fontSize: 15,
    );
    return StreamBuilder(
      initialData: audioPlayerModel.backgroundAudioPositionSeconds,
      stream: audioPlayerModel.audioProgressStreams.stream.asBroadcastStream(),
      builder: (BuildContext? context, dynamic snapshot) {
        double? seekSliderValue = 0;
        if (snapshot.data != null) {
          seekSliderValue = snapshot.data /
              audioPlayerModel.backgroundAudioDurationSeconds.floor();
          if (seekSliderValue!.isNaN || seekSliderValue < 0) {
            seekSliderValue = 0;
          }
          if (seekSliderValue > 1) {
            seekSliderValue = 1;
          }
          print("snapshot.data = " + snapshot.data.toString());
          print("backgroundAudioDurationSeconds = " +
              audioPlayerModel.backgroundAudioDurationSeconds.toString());
          print("seekSliderValue = " + seekSliderValue.toString());
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              TimUtil.stringForSeconds(
                  (snapshot == null || snapshot.data == null)
                      ? 0.0
                      : snapshot.data),
              style: style,
            ),
            Expanded(
              child: Slider(
                  activeColor: Colors.pink,
                  value: seekSliderValue,
                  onChangeEnd: (v) {
                    audioPlayerModel.onStartSeek();
                  },
                  onChanged: (double val) {
                    final double positionSeconds =
                        val * audioPlayerModel.backgroundAudioDurationSeconds;
                    audioPlayerModel.seekTo(positionSeconds);
                  }),
            ),
            new Text(
              TimUtil.stringForSeconds(
                  audioPlayerModel.backgroundAudioDurationSeconds),
              style: style,
            ),
          ],
        );
      },
    );
  }

  List<Widget> _controllers(
      BuildContext context, AudioPlayerProvider audioPlayerModel) {
        
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              onPressed: () {
                audioPlayerModel.skipPrevious();
                Provider.of<MediaPlayerProvider>(context, listen: false)
                    .setMediaLikesCommentsCount(audioPlayerModel.currentMedia!,context.read<UserDetailsCubit>().getUserId());
              },
              icon: Icon(
                //Icons.skip_previous,
                Icons.fast_rewind,
                size: 25.0,
                color: Colors.white,
              ),
            ),
            ClipOval(
                child: Container(
              color: Theme.of(context).colorScheme.secondary.withAlpha(30),
              width: 70.0,
              height: 70.0,
              child: IconButton(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                onPressed: () {
                  audioPlayerModel.onPressed();
                },
                icon: audioPlayerModel.icon(),
              ),
            )),
            IconButton(
              onPressed: () {
                audioPlayerModel.skipNext();
                Provider.of<MediaPlayerProvider>(context, listen: false)
                    .setMediaLikesCommentsCount(audioPlayerModel.currentMedia!,context.read<UserDetailsCubit>().getUserId());
              },
              icon: Icon(
                //Icons.skip_next,
                Icons.fast_forward,
                size: 25.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      Visibility(
        visible: !audioPlayerModel.showList,
        child: new Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: _timer(context, audioPlayerModel),
        ),
      ),
    ];
  }
}
