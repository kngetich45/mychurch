 import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../../../app/appLocalization.dart';
import '../../../app/routes.dart';
import '../../../features/ads/interstitialAdCubit.dart'; 
import '../../../features/mediaPlayers/cubits/MediaPlayerCategoryCubit.dart';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/uiUtils.dart';
import '../../../utils/constants.dart';
import '../../widgets/circularProgressContainner.dart';
import '../../widgets/errorContainer.dart';
  
class HomeCategorySlider extends StatefulWidget {
  //final DashboardCategoryModel dashboardCategoryModel;

  HomeCategorySlider({
    Key? key,
  }) : super(key: key); 

  @override
  _HomeCategorySlider createState() => _HomeCategorySlider();

  static Route<dynamic> route(RouteSettings routeSettings) {
   // Map arguments = routeSettings.arguments as Map;
    return CupertinoPageRoute(
        builder: (_) => HomeCategorySlider(
          // dashboardCategoryModel: arguments['quizType'] as QuizTypes,
            ));
  }
}

class _HomeCategorySlider extends State<HomeCategorySlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<InterstitialAdCubit>().showAd(context);
    }); 
     context.read<MediaPlayerCategoryCubit>().getMediaPlayerCategory(
            context.read<UserDetailsCubit>().getUserId(),
          );
      _initGetData();
    super.initState();
  }

   void _initGetData(){
     Future.delayed(Duration.zero, () {
            context.read<MediaPlayerCategoryCubit>().getMediaPlayerCategory(
            context.read<UserDetailsCubit>().getUserId(),
          );
    });
   }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MediaPlayerCategoryCubit, MediaPlayerCategoryState>(
                            bloc: context.read<MediaPlayerCategoryCubit>(),
                            listener: (context, state) {
                              if (state is MediaPlayerCategoryFetchFailure) {
                                if (state.errorMessage == unauthorizedAccessCode) {
                                  //
                                  UiUtils.showAlreadyLoggedInDialog(
                                    context: context,
                                  );
                                }
                              }
                            },
                            builder: (context, state) {
                              if (state is MediaPlayerCategoryFetchInProgress ||
                                  state is MediaPlayerCategoryInitial) {
                                return Center(
                                  child: CircularProgressContainer(
                                    useWhiteLoader: false,
                                  ),
                                );
                              }
                              if (state is MediaPlayerCategoryFetchFailure) {
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
                              final dashboardCategoryList = (state as MediaPlayerCategoryFetchSuccess).mediaPlayerCategoryList;
                                
                              
                            return Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 10.0, left: 10.0),
                                  height: 165.0,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    primary: false,
                                    itemCount: 3,
                                    itemBuilder: (BuildContext context, int index) {
                                  
                                      
                                      //Categories curObj = items![index];
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 0.0),
                                        child: InkWell(
                                          child: Card(
                                            clipBehavior: Clip.antiAlias,
                                            elevation: 8, 
                                            shadowColor: Colors.black, 
                                            child: Container(
                                              height: 120.0,
                                              width: 120.0,
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(height: 7.0),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Container(
                                                      height: 100.0,
                                                      width: 100.0,
                                                      child: 
                                                      
                                                     CachedNetworkImage(
                                                        imageUrl: databaseUrl+'/images/category/'+dashboardCategoryList[index].thumbnailUrl.toString(),
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
                                                    padding: EdgeInsets.only(right: 2,left: 2),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      dashboardCategoryList[index].title.toString(),
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.normal,
                                                        fontSize: 14.0,
                                                      ),
                                                      maxLines: 1,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () { 
                                       Navigator.of(context).pushNamed(Routes.homeCategoryAllSingleList, arguments: {
                                                              "catId": dashboardCategoryList[index].id,
                                                               "catTile": dashboardCategoryList[index].title,
                                                            }); 
                                            
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
   