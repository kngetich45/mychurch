 
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../app/appLocalization.dart';
import '../../../app/routes.dart';
import '../../../features/hymns/HymnsRepository.dart';
import '../../../features/hymns/cubits/HymnsCubit.dart'; 
import 'dart:async';
import 'dart:math';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../features/systemConfig/cubits/systemConfigCubit.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/uiUtils.dart'; 
import '../../../features/hymns/models/HymnsModel.dart';
import '../../widgets/circularProgressContainner.dart';
import '../../widgets/errorContainer.dart'; 
import '../../../i18n/strings.g.dart';
import '../../../ui/styles/TextStyles.dart'; 
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HymnsListScreen extends StatefulWidget {
  static const routeName = "/hymnslist";
   final int itemId;
  const HymnsListScreen({Key?key, required this.itemId}): super(key: key);
 

  @override
  State<HymnsListScreen> createState() => _HymnsListScreenState();
  static Route<dynamic> route(RouteSettings routeSettings) { 
    Map arguments = routeSettings.arguments as Map;
      return CupertinoPageRoute(
         builder: (_) => BlocProvider<HymnsCubit>(
            create: (_) => HymnsCubit(HymnsRepository()),
            child: HymnsListScreen(
              itemId: arguments["ItemId"],
            )));
  }
}

class _HymnsListScreenState extends State<HymnsListScreen> {
  bool showClear = false;
  String query = ""; 
  final TextEditingController inputController = new TextEditingController();

  List<HymnsModel>? items = []; 
  RefreshController refreshController = RefreshController(initialRefresh: false); 
   BannerAd? _googleBannerAd;
  final _kAdIndex = 4;

 
    
  @override
  void initState() { 
     super.initState();
    Future.delayed(Duration.zero, () {
        context.read<HymnsCubit>().getHymns( 
          query: '',
          hymnsId: widget.itemId,
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
        context.read<HymnsCubit>().getHymns( 
          query: '',
          hymnsId: widget.itemId,
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
            hintText: t.hymns,
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
                        .pushNamed(Routes.hymnsCategory);*/
          }, 
        ),
        actions: <Widget>[
          showClear
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    inputController.clear();
                    showClear = false;
                    setState(() {
                      query = "";
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.bookmark),
                  onPressed: () {
                  /*   Navigator.of(context)
                        .pushNamed(BookmarkedHymnsListScreen.routeName); */
                  }),
        ],
      ),
      body: Padding( 
        padding: EdgeInsets.only(top: 12),
        child: _hymnScreenBody(context, widget.itemId,_googleBannerAd, _kAdIndex),
      ),
    );
  }
} 


  Widget _hymnScreenBody (BuildContext context, itemIds,BannerAd? _googleBannerAd ,  final _kAdIndex ) {
 
    return BlocConsumer<HymnsCubit, HymnsState>(
        bloc: context.read<HymnsCubit>(),
        listener: (context, state) {
          if (state is  HymnsFailure) {
            if (state.errorMessage == unauthorizedAccessCode) {
              //
              print(state.errorMessage);
              UiUtils.showAlreadyLoggedInDialog(context: context);
            }
          }
        },
        builder: (context, state) {
          if (state is  HymnsFetchInProgress || state is  HymnsInitial) {
            return Center(
              child: CircularProgressContainer(
                useWhiteLoader: false,
              ),
            );
          }
          if (state is HymnsFailure) {
            return ErrorContainer(
              showBackButton: false,
              errorMessageColor: Theme.of(context).primaryColor,
              showErrorImage: true,
              errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                convertErrorCodeToLanguageKey(state.errorMessage),
              ),
              onTapRetry: () {
                context.read<HymnsCubit>().getHymns( 
                    query: '',
                    hymnsId: itemIds,
                    userId: context.read<UserDetailsCubit>().getUserId(),
                    );
              },
            );
          }
          final hymnsList = (state as HymnsSuccess).hymnsList;

          return Container(
              height: MediaQuery.of(context).size.height,  
             width: MediaQuery.of(context).size.width,
                   
            child: ListView.builder(
                itemCount: hymnsList.length,
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
                        final item = hymnsList[_getDestinationItemIndex(index)];
                  return InkWell(
                            onTap: () { 
                                     Navigator.of(context)
                                          .pushNamed(Routes.hymnsViwer, arguments: { 
                                        "position": 0,
                                        "items": hymnsList[index],
                                        "itemsList": [], 
                                 });
                            },
                            child: Container(
                              height: 60,
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
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors
                                                .primaries[Random().nextInt(Colors.primaries.length)],
                                            child: Text(
                                              item.title!.substring(0, 1),
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ), 
                                       Container(
                                          width: 270,
                                          padding: EdgeInsets.only(left: 20),
                                          alignment: Alignment.centerLeft,  
                                       
                                        child: RichText(
                                          maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        strutStyle: StrutStyle(fontSize: 18.0),
                                        text: TextSpan(
                                            style: TextStyles.medium(context).copyWith(fontWeight: FontWeight.w500, fontSize: 17),
                                            text: item.title.toString()),
                                        ),
                                       
                                    ),  
                                    
                                      ],
                                    ),
                                    
                                  ),

                           //       if bookekedMarked
                                    /*  Container(
                                    alignment: Alignment.centerRight,
                                      child: Consumer<HymnsBookmarksModel>(
                                        builder: (context, bookmarksModel, child) {
                                          bool isBookmarked =
                                              bookmarksModel.isHymnBookmarked(hymnsList[index]);
                                          return InkWell(
                                            child: Icon(Icons.bookmark,
                                                color: isBookmarked
                                                    ? Colors.redAccent
                                                    : Colors.grey,
                                                size: 20.0),
                                            onTap: () {
                                              if (isBookmarked)
                                                bookmarksModel.unBookmarkHymn(hymnsList[index]);
                                              else
                                                bookmarksModel.bookmarkHymn(hymnsList[index]);
                                            },
                                          );
                                        },
                                      ),
                                    ), */
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

/*   class ItemTile extends StatelessWidget {
  final HymnsModel object;

  const ItemTile({
    Key? key,
    required this.object,
  })  : 
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screen =  MediaQuery.of(context).size/2;
    return InkWell(
      onTap: () {
        print("thumbnail = " + object.thumbnail!);
        Navigator.of(context).pushNamed(HymnsViewerScreen.routeName,
            arguments: ScreenArguements(
              position: 0,
              items: object,
              itemsList: [],
            ));
      },
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(10, 5, 15, 5),
        child: Column(
          children: <Widget>[
            Expanded( 
              child: Row(
                
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 40,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      child: Text(
                        object.title!.substring(0, 1),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
 

                  Container(
                    width: 270,
                    padding: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,  
                  child:Flexible(
                  child: RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(fontSize: 18.0),
                  text: TextSpan(
                      style: TextStyles.headline(context).copyWith(fontWeight: FontWeight.w500, fontSize: 17),
                      text: object.title!),
                   ),
                  ),
              ),
                
           

            /*  Container(
            padding: EdgeInsets.all(4.0),
            color: Colors.lime, 
            child: Row(
            children: <Widget>[
              Container(
              width: _screen.width * 0.4,
                child:Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(fontSize: 18.0),
                  text: TextSpan(
                      style: TextStyles.headline(context).copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                      text: object.title!),
                   ),
                  ),
              ),
              Container(
              width: _screen.width * 0.45,
                child: Consumer<HymnsBookmarksModel>(
                  builder: (context, bookmarksModel, child) {
                    bool isBookmarked =
                        bookmarksModel.isHymnBookmarked(object);
                    return InkWell(
                      child: Icon(Icons.bookmark,
                          color: isBookmarked
                              ? Colors.redAccent
                              : Colors.grey,
                          size: 20.0),
                      onTap: () {
                        if (isBookmarked)
                          bookmarksModel.unBookmarkHymn(object);
                        else
                          bookmarksModel.bookmarkHymn(object);
                      },
                    );
                  },
                ),
              ),
               ],
              ),
            ),
 */




               /*    Expanded(   
                    
                       child:Row(
                       
                              children: <Widget>[

                            Align(
                              
                            alignment: Alignment.centerLeft,
                          //  child: Text(object.title!,
                             child: Text(object.title!,overflow: TextOverflow.ellipsis, 
                                maxLines: 2,
                                style: TextStyles.headline(context).copyWith(
                                    //color: MyColors.grey_80,
                                    fontWeight: FontWeight.w500, fontSize: 18)),
                               
                          ),

                             Spacer(),

                            Consumer<HymnsBookmarksModel>(
                              builder: (context, bookmarksModel, child) {
                                bool isBookmarked =
                                    bookmarksModel.isHymnBookmarked(object);
                                return InkWell(
                                  child: Icon(Icons.bookmark,
                                      color: isBookmarked
                                          ? Colors.redAccent
                                          : Colors.grey,
                                      size: 20.0),
                                  onTap: () {
                                    if (isBookmarked)
                                      bookmarksModel.unBookmarkHymn(object);
                                    else
                                      bookmarksModel.bookmarkHymn(object);
                                  },
                                );
                              },
                            ),
                               
                              ],
                            ),
                         
                     
                  ) */
                ],
              ),
              
            ),
               Container(
              alignment: Alignment.centerRight,
                child: Consumer<HymnsBookmarksModel>(
                  builder: (context, bookmarksModel, child) {
                    bool isBookmarked =
                        bookmarksModel.isHymnBookmarked(object);
                    return InkWell(
                      child: Icon(Icons.bookmark,
                          color: isBookmarked
                              ? Colors.redAccent
                              : Colors.grey,
                          size: 20.0),
                      onTap: () {
                        if (isBookmarked)
                          bookmarksModel.unBookmarkHymn(object);
                        else
                          bookmarksModel.bookmarkHymn(object);
                      },
                    );
                  },
                ),
              ),
            Divider(
              height: 0.1,
              //color: Colors.grey.shade800,
            )
          ],
        ),
      ),
    );
  }
}
 */