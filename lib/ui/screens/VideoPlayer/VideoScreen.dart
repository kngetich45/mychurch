import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../../../app/appLocalization.dart';
import '../../../features/mediaPlayers/MediaPlayerRepository.dart';
import '../../../features/mediaPlayers/cubits/MediaPlayerCubit.dart';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../features/providers/AudioPlayerProvider.dart';
import '../../../features/providers/BookmarksProvider.dart';
import '../../../features/providers/DownloadsProvider.dart';
import '../../../features/providers/SubscriptionProvider.dart';
import '../../../i18n/strings.g.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/uiUtils.dart';
import '../../widgets/circularProgressContainner.dart';
import '../../widgets/errorContainer.dart';
import 'widget/MediaItemVideoTile.dart'; 

class VideoScreen extends StatefulWidget {
  static const routeName = "/videoscreen";
  VideoScreen();

  @override 
  State<VideoScreen> createState() => _VideoScreenRouteState();
   static Route<dynamic> route(RouteSettings routeSettings){
     // Map arguments = routeSettings.arguments as Map; 
     
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
              child: VideoScreen(),
            ));
  }
}

class _VideoScreenRouteState extends State<VideoScreen> {
 
  void _onRefresh() async {
    Future.delayed(Duration.zero,() {
       context.read<MediaPlayerCubit>().getVideoPlayerData(
           userId: context.read<UserDetailsCubit>().getUserId(),
           userEmail: context.read<UserDetailsCubit>().getUserEmail()
       );
     });
  }
 
  @override
  void initState() { 
     Future.delayed(Duration.zero,() {
       context.read<MediaPlayerCubit>().getVideoPlayerData(
           userId: context.read<UserDetailsCubit>().getUserId(),
           userEmail: context.read<UserDetailsCubit>().getUserEmail()
       );
     });
     super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(t.videomessages),
          backgroundColor: primaryColor,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 12),
          child: _videoScreenBody(context),
        ),
      ); 
  }
   

  Widget _videoScreenBody(BuildContext context) {
     
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
        return ListView.builder(
              itemCount: mediaPlayerList.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(3),
              itemBuilder: (BuildContext context, int index) {
                return MediaItemVideoTile(
                  mediaList: mediaPlayerList,
                  index: index,
                  object: mediaPlayerList[index],
                );
              },
            );

       });
 
  }
}
