 
import 'package:flutter/material.dart'; 
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/appLocalization.dart';
import '../../../app/routes.dart';
import '../../../features/ads/interstitialAdCubit.dart';  
import '../../../features/mediaPlayers/MediaPlayerRepository.dart';
import '../../../features/mediaPlayers/cubits/MediaPlayerCubit.dart';
import '../../../features/mediaPlayers/models/MediaPlayerModel.dart';  
import '../../../features/profileManagement/cubits/updateUserDetailsCubit.dart';
import '../../../features/profileManagement/profileManagementRepository.dart';
import '../../../features/providers/AudioPlayerProvider.dart';  
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../utils/Utility.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/uiUtils.dart'; 
import '../../widgets/circularProgressContainner.dart';
import '../../widgets/errorContainer.dart';
import 'package:provider/provider.dart';

class HomeSliderVideo extends StatefulWidget {
  //final DashboardCategoryModel dashboardCategoryModel;

  HomeSliderVideo({
    Key? key,
  }) : super(key: key); 

  @override
  _HomeSliderVideo createState() => _HomeSliderVideo();

  static Route<dynamic> route(RouteSettings routeSettings) {
  

      return CupertinoPageRoute(
        builder: (context) => MultiProvider(
              providers: [
                BlocProvider<MediaPlayerCubit>(
                  create: (_) => MediaPlayerCubit(MediaPlayerRepository()),
                ),
                BlocProvider<UpdateUserDetailCubit>(
                  create: (context) =>
                      UpdateUserDetailCubit(ProfileManagementRepository()),
                ),
                ChangeNotifierProvider<AudioPlayerProvider>(
                          create: (context) => AudioPlayerProvider(),
                        ),
                 
              ],
              child: HomeSliderVideo(),
            ));
  }
}

class _HomeSliderVideo extends State<HomeSliderVideo> {
  final ScrollController scrollController = ScrollController();
 

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<InterstitialAdCubit>().showAd(context);
    }); 
     /* context.read<MediaPlayerCubit>().getMediaPlayer(
            context.read<UserDetailsCubit>().getUserId(),
          ); */
      _initGetData();
    super.initState();
  }

   void _initGetData(){
     Future.delayed(Duration.zero, () {
            context.read<MediaPlayerCubit>().getDashboardVideos(
            context.read<UserDetailsCubit>().getUserId(),
            context.read<UserDetailsCubit>().getUserEmail(),
          );
    });
   } 

  @override
  Widget build(BuildContext context) {
     
    return BlocConsumer<MediaPlayerCubit, MediaPlayerState>(
                            bloc: context.read<MediaPlayerCubit>(),
                            listener: (context, state) {
                              if (state is MediaPlayerFailure) {
                                if (state.errorMessage == unauthorizedAccessCode) {
                                  //
                                  UiUtils.showAlreadyLoggedInDialog(
                                    context: context,
                                  );
                                }
                              }
                            },
                            builder: (context, state) {
                              if (state is MediaPlayerFetchInProgress ||
                                  state is MediaPlayerInitial) {
                                return Center(
                                  child: CircularProgressContainer(
                                    useWhiteLoader: false,
                                  ),
                                );
                              }
                              if (state is MediaPlayerFailure) {
                                return Center(
                                  child: ErrorContainer(
                                    showBackButton: false,
                                    errorMessageColor: Theme.of(context).primaryColor,
                                    showErrorImage: true,
                                    errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                                      convertErrorCodeToLanguageKey(state.errorMessage),
                                    ),
                                    onTapRetry: () {
                                      _initGetData();
                                    },
                                  ),
                                );
                              }
                            List<MediaPlayerModel> dashboardVideoList = (state as MediaPlayerSuccess).mediaPlayerList;
                                
                              
                            return  Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                                      height: 160.0,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        primary: false,
                                        itemCount:
                                            (dashboardVideoList.length == 0) ? 0 : dashboardVideoList.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          MediaPlayerModel curObj = dashboardVideoList[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 10.0),
                                            child: InkWell(
                                              child: Container(
                                                height: 120.0,
                                                width: 120.0,
                                                child: Column(
                                                  children: <Widget>[
                                                    SizedBox(height: 7.0),
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Container(
                                                        height: 110.0,
                                                        width: 110.0,
                                                        child: CachedNetworkImage(
                                                          imageUrl: curObj.coverPhoto!,
                                                          imageBuilder: (context, imageProvider) =>
                                                              Container(
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                image: imageProvider,
                                                                fit: BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder: (context, url) =>
                                                              Center(child: CupertinoActivityIndicator()),
                                                          errorWidget: (context, url, error) => Center(
                                                              child: Icon(
                                                            Icons.error,
                                                            color: Colors.grey,
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 7.0),
                                                    Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        curObj.title!,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: 15.0,
                                                        ),
                                                        maxLines: 1,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                if (curObj.mediaType!.toLowerCase() == "audio") {
                                                          Navigator.of(context).pushNamed(Routes.audioPlayer, 
                                                            arguments: {
                                                              "position": 0,
                                                              "items": curObj,
                                                              "itemsList": Utility.extractMediaByType(
                                                                  dashboardVideoList, curObj.mediaType),
                                                            }); 

                                                } else {
                                               
                                                      Navigator.of(context)
                                                                    .pushNamed(Routes.videoplayer, arguments: { 
                                                                  "position": 0,
                                                                  "items": curObj,
                                                                  "itemsList": Utility.extractMediaByType(
                                                            dashboardVideoList, curObj.mediaType),
                                                      });    
                                                      
                                                        
                                                }
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ); 

                              });   

                              }
                            }
                              