import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RotatePlayer extends AnimatedWidget {
  final String? coverPhoto;
  RotatePlayer({Key? key, required Animation<double> animation, this.coverPhoto})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return GestureDetector(
      onTap: () {},
      child: RotationTransition(
        turns: animation,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: CachedNetworkImageProvider(coverPhoto!),
            ),
          ),
        ),
      ),
    );
  }
}
