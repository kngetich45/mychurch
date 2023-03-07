import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart'; 
 

class PlayingControls extends StatelessWidget {
  final bool isPlaying;
  final LoopMode? loopMode;
  final bool isPlaylist;
  final Function()? onPrevious;
  final Function() onPlay;
  final Function()? onNext;
  final Function()? toggleLoop;
  final Function()? onStop;

  PlayingControls({
    required this.isPlaying,
    this.isPlaylist = false,
    this.loopMode,
    this.toggleLoop,
    this.onPrevious,
    required this.onPlay,
    this.onNext,
    this.onStop,
  });

  Widget _loopIcon(BuildContext context) {
    final iconSize = 34.0;
    if (loopMode == LoopMode.none) {
      return Icon(
        Icons.loop,
        size: iconSize,
        color: Colors.grey,
      );
    } else if (loopMode == LoopMode.playlist) {
      return Icon(
        Icons.loop,
        size: iconSize,
        color: Colors.black,
      );
    } else {
      //single
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.loop,
            size: iconSize,
            color: Colors.black,
          ),
          Center(
            child: Text(
              '1',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () {
            if (toggleLoop != null) toggleLoop!();
          },
          child: _loopIcon(context),
        ),
        SizedBox(
          width: 12,
        ),
        NeumorphicButton(
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
          ),
          padding: EdgeInsets.all(18),
          onPressed: isPlaylist ? onPrevious : null,
          child: Icon(Icons.skip_previous, size: 30, color: Colors.black,),
        ),
        SizedBox(
          width: 12,
        ),
        NeumorphicButton(
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
          ),
          padding: EdgeInsets.all(24),
          onPressed: onPlay,
          child:  
            isPlaying
                 ? Icon(Icons.pause, size: 30, color: Colors.red,)
                 : Icon(Icons.play_arrow,size: 30, color: Colors.black,)

           // size: 32,
         // ),
        ),
        SizedBox(
          width: 12,
        ),
        NeumorphicButton(
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
          ),
          padding: EdgeInsets.all(18),
          onPressed: isPlaylist ? onNext : null,
          child: Icon(Icons.skip_next, size: 30, color: Colors.black,),
        ),
        SizedBox(
          width: 5,
        ),
        if (onStop != null)
          NeumorphicButton(
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.circle(),
            ),
            padding: EdgeInsets.all(16),
            onPressed: onStop,
            child: Icon(
              Icons.stop,
              
              size: 32,
            ),
          ),
      ],
    );
  }
}