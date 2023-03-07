import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../app/appLocalization.dart';
import '../../../features/mediaPlayers/MediaPlayerRepository.dart';
import '../../../features/mediaPlayers/cubits/MediaPlayerCubit.dart';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../features/providers/AudioPlayerProvider.dart'; 
import '../../../features/providers/BookmarksProvider.dart';
import '../../../features/providers/DownloadsProvider.dart';
import '../../../features/providers/SubscriptionProvider.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/uiUtils.dart';
import '../../widgets/circularProgressContainner.dart';
import '../../widgets/errorContainer.dart';
import '../NoitemScreen.dart'; 
import '../../../i18n/strings.g.dart';
import 'widgets/MediaCategoryItemTiles.dart';  

class HomeCategoryAllSingleList extends StatefulWidget {
  static const routeName = "/homeCategoryAllSingleList"; 
  final String catId;
  final String catTile;
  const HomeCategoryAllSingleList({Key? key, required this.catId, required this.catTile}) : super(key: key);

  @override
  //AudioScreenRouteState createState() => new AudioScreenRouteState();
   State<HomeCategoryAllSingleList> createState() => _HomeCategoryAllSingleListState();
   static Route<dynamic> route(RouteSettings routeSettings){
    Map arguments = routeSettings.arguments as Map; 
     
       return CupertinoPageRoute(
        builder: (_) => MultiProvider(
                providers: [BlocProvider<MediaPlayerCubit>(
                      create: (_) => MediaPlayerCubit(MediaPlayerRepository())), 
                       ChangeNotifierProvider<AudioPlayerProvider>(
                          create: (_) => AudioPlayerProvider(),
                        ),
                        ChangeNotifierProvider<SubscriptionProvider>(
                          create: (_) => SubscriptionProvider(),
                        ),
                         ChangeNotifierProvider<BookmarksProvider>(
                          create: (_) => BookmarksProvider(),
                        ),
                        ChangeNotifierProvider<DownloadsProvider>(
                          create: (_) => DownloadsProvider(),
                        ),
                        
                         
                     // ChangeNotifierProvider.value(value: BibleProvider()),
                      ],
              child: HomeCategoryAllSingleList(catId: arguments['catId'],catTile:arguments['catTile']),
            ));
  }
}

class _HomeCategoryAllSingleListState extends State<HomeCategoryAllSingleList> { 
  RefreshController refreshController =  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    Future.delayed(Duration.zero,() {
       context.read<MediaPlayerCubit>().getMediaByCategory(
           userId: context.read<UserDetailsCubit>().getUserId(),
           userEmail: context.read<UserDetailsCubit>().getUserEmail(),
           catId: widget.catId,
       );
     });
  }

  /* void _onLoading() async {
    mediaScreensModel.loadMoreItems();
  } */

  @override
  void initState() {
    Future.delayed(Duration.zero,() {
       context.read<MediaPlayerCubit>().getMediaByCategory(
           userId: context.read<UserDetailsCubit>().getUserId(),
           userEmail: context.read<UserDetailsCubit>().getUserEmail(),
           catId: widget.catId,
       );
     });
    super.initState();
     
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(widget.catTile),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 12),
          child: _audioScreenBody(context),
        ),
    );
  }
   
  Widget _audioScreenBody(BuildContext context) {
  return BlocConsumer<MediaPlayerCubit, MediaPlayerState>(
      bloc: context.read<MediaPlayerCubit>(), 
      listener: (context, state){
        if(state is MediaPlayerFailure){
          if(state.errorMessage == unauthorizedAccessCode){
            UiUtils.showAlreadyLoggedInDialog(context: context);
          }
        }
      },
       builder: (context, state){
        if(state is MediaPlayerFetchInProgress || state is MediaPlayerInitial){
          return Center(
            child: CircularProgressContainer(useWhiteLoader: false),
          );
        }
        if(state is MediaPlayerFailure){
          return Center(
            child: ErrorContainer(
              showBackButton: false,
              errorMessageColor: Theme.of(context).primaryColor,
              errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                convertErrorCodeToLanguageKey(state.errorMessage)
              ),
              onTapRetry: (){_onRefresh();},
              showErrorImage: true),
          );
        }

        final mediaPlayerList = (state as MediaPlayerSuccess).mediaPlayerList;
        return SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus? mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = Text(t.pulluploadmore);
                    } else if (mode == LoadStatus.loading) {
                      body = CupertinoActivityIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = Text(t.loadfailedretry);
                    } else if (mode == LoadStatus.canLoading) {
                      body = Text(t.releaseloadmore);
                    } else {
                      body = Text(t.nomoredata);
                    }
                    return Container(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  },
                ),
                controller: refreshController,
                onRefresh: _onRefresh,
             //   onLoading: _onLoading,
                child: (mediaPlayerList.length == 0)
                    ? NoitemScreen(
                        title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
                    : ListView.builder(
                        itemCount: mediaPlayerList.length,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(3),
                        itemBuilder: (BuildContext context, int index) {
                          return MediaCategoryItemTiles(
                            mediaList: mediaPlayerList,
                            index: index,
                            object: mediaPlayerList[index],
                          );
                        },
                      ),
              );
 

       }
      );
  }
}