import 'package:flutter/material.dart';
import 'package:bevicschurch/ui/widgets/customBackButton.dart';
import 'package:bevicschurch/utils/uiUtils.dart';

class RoundedAppbar extends StatelessWidget {
  final String title;
  final Widget? trailingWidget;
  final bool? removeSnackBars;
  final Color? appBarColor;
  final Color? appTextAndIconColor;
  RoundedAppbar(
      {Key? key,
      required this.title,
      this.trailingWidget,
      this.removeSnackBars,
      this.appBarColor,
      this.appTextAndIconColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: 12.0),
              child: CustomBackButton(
                removeSnackBars: removeSnackBars,
                iconColor:
                    appTextAndIconColor ?? Theme.of(context).backgroundColor,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Text(
              "$title",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22.0,
                  color: appTextAndIconColor ?? Theme.of(context).backgroundColor),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: trailingWidget ?? Container(),
          ),
        ],
      ),
      height: 80,
        //  MediaQuery.of(context).size.height * UiUtils.appBarHeightPercentage/1.5,
      decoration: BoxDecoration(
          boxShadow: [UiUtils.buildAppbarShadow()],
          color: appBarColor ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(1.0),
              bottomRight: Radius.circular(1.0))),
    );
  }
}
