import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/providers/AudioPlayerProvider.dart'; 

class RadioCarousal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AudioPlayerProvider radioPlayerModel = Provider.of<AudioPlayerProvider>(context);
    return Column(
      children: _controllers(context, radioPlayerModel),
    );
  }

  List<Widget> _controllers(
      BuildContext context, AudioPlayerProvider radioPlayerModel) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ClipOval(
                child: Container(
              color: Theme.of(context).colorScheme.secondary.withAlpha(30),
              width: 100.0,
              height: 100.0,
              child: IconButton(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                onPressed: () {
                  radioPlayerModel.onPressed();
                },
                icon: radioPlayerModel.icon(),
              ),
            )),
          ],
        ),
      ),
    ];
  }
}
