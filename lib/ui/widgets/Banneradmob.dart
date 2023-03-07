import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../utils/Adverts.dart';

class Banneradmob extends StatefulWidget {
  const Banneradmob({Key? key}) : super(key: key);

  @override
  _BanneradmobState createState() => _BanneradmobState();
}

class _BanneradmobState extends State<Banneradmob> {
  final BannerAd myBanner = BannerAd(
    adUnitId: Adverts.getBannerAdUnitId()!,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  AdWidget? adWidget;
  @override
  void initState() {
    super.initState();
    adWidget = AdWidget(ad: myBanner);
    myBanner.load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );
  }
}
