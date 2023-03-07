 

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/appLocalization.dart';
import '../../../app/routes.dart';
import '../../../features/mediaPlayers/MediaPlayerRepository.dart';
import '../../../features/mediaPlayers/cubits/MediaPlayerCategoryCubit.dart';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../i18n/strings.g.dart';
import '../../../utils/constants.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/uiUtils.dart';
import '../../styles/colors.dart';
import '../../widgets/circularProgressContainner.dart';
import '../../widgets/errorContainer.dart';

class HomeCategoryAll extends StatefulWidget {
  const HomeCategoryAll({Key? key}) : super(key: key);

  @override
  State<HomeCategoryAll> createState() => _HomeCategoryAllState();
  static Route<dynamic> route(RouteSettings routeSettings){
    return CupertinoPageRoute(builder: (_)=> BlocProvider<MediaPlayerCategoryCubit>(
                                            create: (_) => MediaPlayerCategoryCubit(MediaPlayerRepository()),  
                                           child: HomeCategoryAll()));
  }
}

class _HomeCategoryAllState extends State<HomeCategoryAll> {
  @override
  void initState() {
     /* Future.delayed(Duration.zero,() {
       context.read<MediaPlayerCategoryCubit>().getMediaPlayerCategory(
           userId: context.read<UserDetailsCubit>().getUserId(),
       );
     }); */
     _initGetData();
    super.initState();
  }
    _initGetData(){
     Future.delayed(Duration.zero,() {
        context.read<MediaPlayerCategoryCubit>().getMediaPlayerCategory(
            context.read<UserDetailsCubit>().getUserId(),
          );
     });
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.categories),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back
          ),
          onPressed: () {
            //  Navigator.of(context).pushNamed(Routes.dashboard);
            Navigator.pop(context);
          },
        ),

      ),
      backgroundColor: Color.fromARGB(255, 243, 241, 241),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: _hymCatBuild(context),
      ),

    ); 
  }
 // @override
 Widget _hymCatBuild(BuildContext context){

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
                                return Container( 
                                            height: MediaQuery.of(context).size.height,  
                                            width: MediaQuery.of(context).size.width,
                                            child: LayoutBuilder(builder: (context, constraints){
                                              return  GridView.builder( 
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1),
                                                      itemCount: dashboardCategoryList.length,
                                                      itemBuilder: (BuildContext context, int index) { 
                                                        return InkWell(
                                                          onTap: (){
                                                             
                                                            
                                                           Navigator.of(context).pushNamed(Routes.homeCategoryAllSingleList, arguments: {
                                                              "catId": dashboardCategoryList[index].id,
                                                               "catTile": dashboardCategoryList[index].title,
                                                            });  
                                                          }, 
                                                          child: Container(   
                                                              padding: new EdgeInsets.only(top: 0.0),  
                                                                child: Card(
                                                                  clipBehavior: Clip.antiAlias,
                                                                  elevation: 4, 
                                                                  color: Colors.white,
                                                                  shadowColor: Colors.black, 
                                                                
                                                                    child: Column(
                                                                      children: <Widget>[ 
                                                                    SizedBox(height: 3.0),
                                                                        ClipRRect(
                                                                          borderRadius: BorderRadius.circular(5),
                                                                          child: Container(
                                                                            height: 80.0, 
                                                                            child: CachedNetworkImage(
                                                                              imageUrl: categoryImage+dashboardCategoryList[index].thumbnailUrl.toString(),
                                                                              imageBuilder: (context, imageProvider) =>
                                                                                  Container(
                                                                                decoration: BoxDecoration(
                                                                                  image: DecorationImage(
                                                                                    image: imageProvider,
                                                                                    fit: BoxFit.cover,
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
                                                                            dashboardCategoryList[index].title.toString(),
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
                                                              ),
                                                        );
                                                      },
                                            );
                                            })
                                          
                                          );

       },
      );

 }
}