import 'package:bevicschurch/features/hymns/HymnsRepository.dart';
import 'package:bevicschurch/features/hymns/cubits/HymnsCategoryCubit.dart';
import 'package:bevicschurch/features/profileManagement/cubits/userDetailsCubit.dart';
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:bevicschurch/ui/widgets/circularProgressContainner.dart';
import 'package:bevicschurch/ui/widgets/errorContainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/appLocalization.dart';
import '../../../app/routes.dart';
import '../../../i18n/strings.g.dart';
import '../../../utils/constants.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/uiUtils.dart';
import '../../widgets/bannerAdContainer.dart';

class HymnsCategoryScreen extends StatefulWidget {
  const HymnsCategoryScreen({Key? key}) : super(key: key);

  @override
  State<HymnsCategoryScreen> createState() => _HymnsCategoryScreenState();
  static Route<dynamic> route(RouteSettings routeSettings){
    return CupertinoPageRoute(builder: (_)=> BlocProvider<HymnsCategoryCubit>(
                                            create: (_) => HymnsCategoryCubit(HymnsRepository()),  
                                           child: HymnsCategoryScreen()));
  }
}

class _HymnsCategoryScreenState extends State<HymnsCategoryScreen> {
  @override
  void initState() {
     Future.delayed(Duration.zero,() {
       context.read<HymnsCategoryCubit>().getHymnsCategory(
           userId: context.read<UserDetailsCubit>().getUserId(),
       );
     });
     _initGetData();
    super.initState();
  }
  _initGetData(){
     Future.delayed(Duration.zero,() {
       context.read<HymnsCategoryCubit>().getHymnsCategory(
           userId: context.read<UserDetailsCubit>().getUserId(),
       );
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text(t.hymns),
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: _hymCatBuild(context),
      ),

    ); 
  }
 // @override
 Widget _hymCatBuild(BuildContext context){

  return BlocConsumer<HymnsCategoryCubit, HymnsCategoryState>(
      bloc: context.read<HymnsCategoryCubit>(), 
      listener: (context, state){
        if(state is HymnsCategoryFailure){
          if(state.errorMessage == unauthorizedAccessCode){
            UiUtils.showAlreadyLoggedInDialog(context: context);
          }
        }
      },
       builder: (context, state){
        if(state is HymnsCategoryFetchInProgress || state is HymnsCategoryInitial){
          return Center(
            child: CircularProgressContainer(useWhiteLoader: false),
          );
        }
        if(state is HymnsCategoryFailure){
          return Center(
            child: ErrorContainer(
              showBackButton: false,
              errorMessageColor: Theme.of(context).primaryColor,
              errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                convertErrorCodeToLanguageKey(state.errorMessage)
              ),
              onTapRetry: (){_initGetData();},
              showErrorImage: true),
          );
        }

        final hymnsCategoryList = (state as HymnsCategorySuccess).hymnsCategoryList;
         return  Column(
           children: [
             Expanded(  
                        child: LayoutBuilder(builder: (context, constraints){
                          return  GridView.builder( 
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1),
                                  itemCount: hymnsCategoryList.length,
                                  itemBuilder: (BuildContext context, int index) { 
                                    return InkWell(
                                      onTap: (){
                                        
                                        Navigator.of(context).pushNamed(Routes.hymnsHome, arguments: {
                                          "ItemId": hymnsCategoryList[index].id
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
                                                          imageUrl: categoryImage+hymnsCategoryList[index].thumbnail.toString(),
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
                                                        hymnsCategoryList[index].title.toString(),
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
                      ),
                      BannerAdContainer()
           ],
         );

       },
      );

 }
}