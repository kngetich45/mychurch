import 'package:bevicschurch/features/Giving/GivingRepository.dart';
import 'package:bevicschurch/features/Giving/cubits/GivingCategoryCubit.dart';
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

class GivingCategoryScreen extends StatefulWidget {
  const GivingCategoryScreen({Key? key}) : super(key: key);

  @override
  State<GivingCategoryScreen> createState() => _GivingCategoryScreenState();
  static Route<dynamic> route(RouteSettings routeSettings){
    return CupertinoPageRoute(builder: (_)=> BlocProvider<GivingCategoryCubit>(
                                            create: (_) => GivingCategoryCubit(GivingRepository()),  
                                           child: GivingCategoryScreen()));
  }
}

class _GivingCategoryScreenState extends State<GivingCategoryScreen> {
  @override
  void initState() {
     Future.delayed(Duration.zero,() {
       context.read<GivingCategoryCubit>().getGivingCategory(
           userId: context.read<UserDetailsCubit>().getUserId(),
       );
     });
     _initGetData();
    super.initState();
  }
  _initGetData(){
     Future.delayed(Duration.zero,() {
       context.read<GivingCategoryCubit>().getGivingCategory(
           userId: context.read<UserDetailsCubit>().getUserId(),
       );
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text(t.giving),
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

  return BlocConsumer<GivingCategoryCubit, GivingCategoryState>(
      bloc: context.read<GivingCategoryCubit>(), 
      listener: (context, state){
        if(state is GivingCategoryFailure){
          if(state.errorMessage == unauthorizedAccessCode){
            UiUtils.showAlreadyLoggedInDialog(context: context);
          }
        }
      },
       builder: (context, state){
        if(state is GivingCategoryFetchInProgress || state is GivingCategoryInitial){
          return Center(
            child: CircularProgressContainer(useWhiteLoader: false),
          );
        }
        if(state is GivingCategoryFailure){
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

        final givingCategoryList = (state as GivingCategorySuccess).givingCategoryList;
         return  Column(
           children: [
             Expanded(  
                        child: LayoutBuilder(builder: (context, constraints){
                          return  GridView.builder( 
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1),
                                  itemCount: givingCategoryList.length,
                                  itemBuilder: (BuildContext context, int index) { 
                                    return InkWell(
                                      onTap: (){
                                        
                                        Navigator.of(context).pushNamed(Routes.givingHome, arguments: {
                                          "ctemId": givingCategoryList[index].id,
                                          "ctitle": givingCategoryList[index].title
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
                                                          imageUrl: categoryImage+givingCategoryList[index].thumbnail.toString(),
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
                                                        givingCategoryList[index].title.toString(),
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