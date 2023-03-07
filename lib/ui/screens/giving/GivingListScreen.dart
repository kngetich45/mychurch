 
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../app/appLocalization.dart';
import '../../../app/routes.dart';
import '../../../features/Giving/GivingRepository.dart';
import '../../../features/Giving/cubits/GivingCubit.dart';
import 'dart:async';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../features/systemConfig/cubits/systemConfigCubit.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/uiUtils.dart'; 
import '../../../features/Giving/models/GivingModel.dart';
import '../../widgets/circularProgressContainner.dart';
import '../../widgets/errorContainer.dart';
import '../../../ui/styles/TextStyles.dart'; 
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GivingListScreen extends StatefulWidget {
  static const routeName = "/Givinglist";
   final int itemId;
   final String ctitle;
  const GivingListScreen({Key?key, required this.itemId, required this.ctitle}): super(key: key);
 

  @override
  State<GivingListScreen> createState() => _GivingListScreenState();
  static Route<dynamic> route(RouteSettings routeSettings) { 
    Map arguments = routeSettings.arguments as Map;
      return CupertinoPageRoute(
         builder: (_) => BlocProvider<GivingCubit>(
            create: (_) => GivingCubit(GivingRepository()),
            child: GivingListScreen(
              itemId: arguments["ctemId"],
              ctitle: arguments["ctitle"],
            )));
  }
}

class _GivingListScreenState extends State<GivingListScreen> {
  bool showClear = false;
  String query = ""; 
  final TextEditingController inputController = new TextEditingController();

  List<GivingModel>? items = []; 
  RefreshController refreshController = RefreshController(initialRefresh: false); 
   BannerAd? _googleBannerAd;
  final _kAdIndex = 4;

 
    
  @override
  void initState() { 
     super.initState();
    Future.delayed(Duration.zero, () {
        context.read<GivingCubit>().getGiving( 
          query: '',
          givingId: widget.itemId,
          userId: context.read<UserDetailsCubit>().getUserId(),
        );
    });
     _fetchItems();
     

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

  _fetchItems() { 
    Future.delayed(Duration.zero, () {
        context.read<GivingCubit>().getGiving( 
          query: '',
          givingId: widget.itemId,
          userId: context.read<UserDetailsCubit>().getUserId(),
        );
    });
  }
@override
void dispose() { 
  _googleBannerAd?.dispose();

  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: TextField(
          maxLines: 1,
          controller: inputController,
          style: new TextStyle(fontSize: 18, color: Colors.white),
          keyboardType: TextInputType.text,
          onSubmitted: (_query) {
            setState(() {
              query = _query;
              showClear = (_query.length > 0);
            });
          },
          onChanged: (term) {
            /* setState(() {
              showClear = (term.length > 2);
            });*/
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.ctitle,
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.white70),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
             Navigator.pop(context);
          /*  Navigator.of(context)
                        .pushNamed(Routes.GivingCategory);*/
          }, 
        ),
     
      ),
      body: Padding( 
        padding: EdgeInsets.only(top: 12),
        child: _givingcreenBody(context, widget.itemId,_googleBannerAd, _kAdIndex),
      ),
    );
  }
} 


  Widget _givingcreenBody (BuildContext context, itemIds,BannerAd? _googleBannerAd ,  final _kAdIndex ) {
 
    return BlocConsumer<GivingCubit, GivingState>(
        bloc: context.read<GivingCubit>(),
        listener: (context, state) {
          if (state is  GivingFailure) {
            if (state.errorMessage == unauthorizedAccessCode) {
              //
              print(state.errorMessage);
              UiUtils.showAlreadyLoggedInDialog(context: context);
            }
          }
        },
        builder: (context, state) {
          if (state is  GivingFetchInProgress || state is  GivingInitial) {
            return Center(
              child: CircularProgressContainer(
                useWhiteLoader: false,
              ),
            );
          }
          if (state is GivingFailure) {
            return ErrorContainer(
              showBackButton: false,
              errorMessageColor: Theme.of(context).primaryColor,
              showErrorImage: true,
              errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                convertErrorCodeToLanguageKey(state.errorMessage),
              ),
              onTapRetry: () {
                context.read<GivingCubit>().getGiving( 
                    query: '',
                    givingId: itemIds,
                    userId: context.read<UserDetailsCubit>().getUserId(),
                    );
              },
            );
          }
          final givingList = (state as GivingSuccess).givingList;

          return Container(
              height: MediaQuery.of(context).size.height,  
             width: MediaQuery.of(context).size.width,
                   
            child: ListView.builder(
                itemCount: givingList.length,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(3),
                itemBuilder: (BuildContext context, int index) {
                   int _getDestinationItemIndex(int rawIndex) {
                          if (rawIndex >= _kAdIndex && _googleBannerAd != null) {
                            return rawIndex - 1;
                          }
                          return rawIndex;
                        } 
                  
                    if (_googleBannerAd != null && index == _kAdIndex) {
                      
                        return Column(
                           
                           children: [
                            Container(
                              width: _googleBannerAd.size.width.toDouble(),
                              height: 72.0,
                              alignment: Alignment.center,
                              child: AdWidget(ad: _googleBannerAd), 
                            ),
                            Divider(
                                        height: 0.1,
                                         color: Colors.grey.shade500,
                                      )
                          ],  
                        );
                      } else {
                        final item = givingList[_getDestinationItemIndex(index)];
                  return InkWell(
                            onTap: () { 
                                     Navigator.of(context)
                                          .pushNamed(Routes.givingViwer, arguments: { 
                                        "position": 0,
                                        "items": givingList[index],
                                        "itemsList": [], 
                                 });
                            },
                            child: Container(
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(10, 5, 15, 5),
                              child: Column(
                                children: <Widget>[
                                  Container( 
                                    child: Row(
                                      
                                      children: <Widget>[
                                        Container(
                                          height: 40,
                                          width: 40,
                                          padding: EdgeInsets.only(left: 10,bottom: 10),
                                          child: CircleAvatar(
                                            radius: 20,
                                             backgroundColor: Colors.white,
                                               // .primaries[Random().nextInt(Colors.primaries.length)],
                                            child: Icon(Icons.task_alt, color:Colors.grey) /* Text(
                                              item.title!.substring(0, 1),
                                              style: TextStyle(color: Colors.white),
                                            ), */
                                          ),
                                        ), 
                                       Container(
                                          width: 270,
                                          padding: EdgeInsets.only(left: 20,bottom: 20),
                                          alignment: Alignment.centerLeft,  
                                       
                                        child: RichText(
                                          maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        strutStyle: StrutStyle(fontSize: 18.0),
                                        text: TextSpan(
                                            style: TextStyles.headline(context).copyWith(fontWeight: FontWeight.w500, fontSize: 19),
                                            text: item.title.toString()),
                                        ),
                                       
                                    ),  
                                    
                                      ],
                                    ),
                                    
                                  ),
 
                                  Divider(
                                    height: 0.1,
                                     color: Colors.grey.shade500,
                                  )  
                                ],
                              ),
                            ),
                          );

                    }

                },
              ),
          );
         
        });



     } 
 