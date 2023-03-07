import 'package:flutter/material.dart';
import 'package:bevicschurch/app/appLocalization.dart';
import 'package:bevicschurch/ui/widgets/customRoundedButton.dart';
import 'package:bevicschurch/utils/stringLabels.dart';
import 'package:bevicschurch/utils/uiUtils.dart'; 

 class ErrorContainer extends StatelessWidget {
  final String? errorMessage;
  final Function onTapRetry;
  final bool showErrorImage, showRTryButton;
  final double topMargin;
  final Color? errorMessageColor;
  final bool? showBackButton;
  const ErrorContainer(
      {Key? key,
      this.errorMessageColor,
      required this.errorMessage,
      required this.onTapRetry,
      required this.showErrorImage,
      this.topMargin = 0.1,
      this.showBackButton,
      this.showRTryButton = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(top: MediaQuery.of(context).size.height * topMargin),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          showErrorImage
              ? SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset(
                    UiUtils.getImagePath("error.png"),
                  ),
                )
              : Container(),
          showErrorImage
              ? SizedBox(
                  height: 25.0,
                )
              : Container(),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "$errorMessage found",
              style: TextStyle(
                  fontSize: 15.0,
                  color: errorMessageColor ?? Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
          showRTryButton
              ? CustomRoundedButton(
                  widthPercentage: 0.375,
                  backgroundColor: Theme.of(context).backgroundColor,
                  buttonTitle: AppLocalization.of(context)!
                      .getTranslatedValues(retryLbl)!,
                  radius: 5,
                  showBorder: false,
                  height: 40,
                  titleColor: Theme.of(context).colorScheme.secondary,
                  elevation: 5.0,
                  onTap: onTapRetry,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
