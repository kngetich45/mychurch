import 'package:bevicschurch/features/Giving/cubits/GivingCubit.dart';
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../features/Giving/GivingRepository.dart';
import '../../../features/Giving/models/GivingModel.dart';
import '../../../features/systemConfig/cubits/systemConfigCubit.dart';
import '../../../ui/styles/TextStyles.dart'; 
class GivingViewerScreen extends StatefulWidget {
  static const routeName = "/Givingviewer";
  const GivingViewerScreen({Key? key, required this.giving}) : super(key: key);
  final GivingModel giving;

  @override
  _GivingViewerScreenState createState() => _GivingViewerScreenState();
  static Route<dynamic> route(RouteSettings routeSettings){
      Map arguments = routeSettings.arguments as Map;
    return CupertinoPageRoute(
      builder: (_)=> BlocProvider<GivingCubit>(
        create: (_) => GivingCubit(GivingRepository()),
        child: GivingViewerScreen(
             giving: arguments['items']
             
        ),
      )
      );
  }
}

class _GivingViewerScreenState extends State<GivingViewerScreen> {
  BannerAd? _googleBannerAd;
 static final _kAdIndex = 4;

  // ignore: unused_element
  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _googleBannerAd != null) {
      return rawIndex - 1;
    }
    return rawIndex;
  }


@override
void initState() {
  super.initState();
 
  BannerAd(
    adUnitId: context.read<SystemConfigCubit>().googleBannerId(),
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (ad) {
        setState(() {
          _googleBannerAd = ad as BannerAd;
        });
      },
      onAdFailedToLoad: (ad, error) {
        // Releases an ad resource when it fails to load
        ad.dispose();
        print('Ad load failed (code=${error.code} message=${error.message})');
      },
    ),
  ).load();
}
 


  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.giving.title.toString()),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 12),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
               /*  Align(
                  alignment: Alignment.center,
                  child: Text(widget.Giving.title.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyles.headline(context)
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 25)),
                ), */
              /*   Container(height: 20),
                Container(
                  height: 200,
                  //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: widget.Giving!.thumbnail!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black12, BlendMode.darken)),
                        ),
                      ),
                      placeholder: (context, url) =>
                          Center(child: CupertinoActivityIndicator()),
                      errorWidget: (context, url, error) => Center(
                          child: Image.asset(
                        Img.get('worship.jpg'),
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                        //color: Colors.black26,
                      )),
                    ),
                  ),
                ), */
                
                 Divider(
                    height: 0.5,
              //color: Colors.grey.shade800,
                 ),
                 Container(height: 20),
            

            HtmlWidget(
              widget.giving.details.toString(), 
              textStyle: TextStyles.medium(context).copyWith(fontSize: 23),
            ),
  
                Container(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
