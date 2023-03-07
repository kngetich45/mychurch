import 'package:flutter/material.dart';

class UserAchievementContainer extends StatelessWidget {
  final String title;
  final String value;
  const UserAchievementContainer({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).backgroundColor,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 13.0,
            color: Color.fromARGB(255, 243, 240, 240).withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
