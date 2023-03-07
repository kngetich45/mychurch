import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/appLocalization.dart';
import '../../../app/routes.dart';
import '../../../features/profileManagement/cubits/deleteAccountCubit.dart';
import '../../../features/profileManagement/cubits/updateUserDetailsCubit.dart';
import '../../../features/profileManagement/cubits/uploadProfileCubit.dart';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart'; 
import '../../../features/profileManagement/profileManagementRepository.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/stringLabels.dart';
import '../../../utils/uiUtils.dart';
import '../../styles/TextStyles.dart'; 


enum HomeIndex { CATEGORIES, VIDEOS, AUDIOS, BIBLEBOOKS, LIVESTREAMS, RADIO }

class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key,}) : super(key: key);
 // final UserProfile? userdata;

  @override
  _DashboardHomeState createState() => _DashboardHomeState();

   static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (context) => MultiBlocProvider(providers: [
              BlocProvider<DeleteAccountCubit>(
                  create: (_) =>
                      DeleteAccountCubit(ProfileManagementRepository())),
              BlocProvider<UploadProfileCubit>(
                  create: (context) => UploadProfileCubit(
                        ProfileManagementRepository(),
                      )),
              BlocProvider<UpdateUserDetailCubit>(
                  create: (context) => UpdateUserDetailCubit(
                        ProfileManagementRepository(),
                      )),
            ], child: Container()));
  }
}

class _DashboardHomeState extends State<DashboardHome> {
  //HomeProvider? homeProvider;

  @override
  void initState() {
   
 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   // homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      body: BlocConsumer<UserDetailsCubit, UserDetailsState>(
        listener: (context, state) {
          if (state is UserDetailsFetchSuccess) {
          

            if (state.userProfile.name!.isEmpty) {
        //      showUpdateNameBottomSheet();
            } else if (state.userProfile.profileUrl!.isEmpty) {
              Navigator.of(context)
                  .pushNamed(Routes.selectProfile, arguments: false);
            }
          } else if (state is UserDetailsFetchFailure) {
            if (state.errorMessage == unauthorizedAccessCode) {
              UiUtils.showAlreadyLoggedInDialog(context: context);
            }
          }
        },
        bloc: context.read<UserDetailsCubit>(),
        builder: (context, state) {
        return Column( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Appbar(),
            Expanded(
              child: HomePageBody(
              //  homeProvider: homeProvider,
                key: UniqueKey(),
              ),
            ),
 

          ],
          
        );
        }
      //),
       )
    );
  }
}

class HomePageBody extends StatelessWidget {
  const HomePageBody({
    Key? key,
  //  required this.homeProvider,
  }) : super(key: key);

  //final HomeProvider? homeProvider;

  onRetryClick() {
  //  homeProvider!.loadItems();
  }

 

  @override
  Widget build(BuildContext context) {
  
      return SingleChildScrollView(
   
        child: Column(
          children: [
 
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.23,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
               
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,  
                    children: <Widget>[
                        Container(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              height: 140,
                              width: 140,
                              child: CircleAvatar(backgroundImage: AssetImage('assets/images/tournament.png'),),
                            ),
                            Column(
                                children: [
                                  Container(
                                     padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text("Quiz Tournament",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),),
                                ),

                               Container(height: 10,),
 
                                  Container(
                                  child:Row(
                                    children: [
                                      Icon(
                                            Icons.done,
                                            color: Colors.white,
                                            size: 14.0,
                                          ), 
                                   Container(width: 5), 
                                  Text("Total prizes: 1000 coins",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white
                                     
                                  ),),

                                  ],) 
                                 
                                ),
                                   Container(height: 5,),
                                Container(
                                  child:Row(
                                    children: [
                                      Icon(
                                            Icons.done,
                                            color: Colors.white,
                                            size: 14.0,
                                          ),
                                  Container(width: 5),
                                  Text("Enrolment fee: 100 coins",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    
                                     
                                  ),),

                                  ],) 
                                 
                                ),
                                 Container(height: 10,),
                                 
                                  ElevatedButton(
                                    onPressed: (){},
                                    child: const Text("Enroll Now", style: TextStyle(
                                        color: Colors.black,
                                        ),
                                      ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shadowColor: Colors.grey,
                                      
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      textStyle:
                                      const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )
                                    ),
                                    ),
                                

                              ],
                            )
                           
                          ],
                        ),  
                      
                        

                    ],
                  ),
                )
                 
             // ),
            ),


  // Main card
 
               Card(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
                  elevation: 0.00,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                 child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: <Widget>[
               
 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
    
                        Card(
                         clipBehavior: Clip.antiAlias,
                         elevation: 10, 
                         shadowColor: Colors.black,
                         color: Colors.greenAccent[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:  Column(
                            children: <Widget>[
                            FloatingActionButton(
                              heroTag: "fab8",
                              elevation: 5,
                              mini: true,
                              backgroundColor: Colors.red[300],
                              child: Icon(
                                Icons.menu_book,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {
                             //   Navigator.of(context)
                             //       .pushNamed(BibleScreen.routeName);
                              },
                              
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: 80,
                              child: Text(AppLocalization.of(context)!.getTranslatedValues(bible)!,
                                 
                                style: TextStyles.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            )
                           ],
                          ),
                          ),

                        ),

                        Card(
                         clipBehavior: Clip.antiAlias,
                         elevation: 10, 
                         shadowColor: Colors.black,
                         color: Colors.greenAccent[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                            children: <Widget>[
                            FloatingActionButton(
                              heroTag: "fab3",
                              elevation: 5,
                              mini: true,
                              backgroundColor: Colors.purple[400],
                              child: Icon(
                                Icons.library_books,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {
                            //    Navigator.of(context)
                              //      .pushNamed(HymnsListScreen.routeName);
                              },
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: 80,
                              child: Text(AppLocalization.of(context)!.getTranslatedValues(hymns)!,
                                
                                style: TextStyles.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                          ),
                          ),

                        ),
 
                        Card(
                         clipBehavior: Clip.antiAlias,
                         elevation: 10, 
                         shadowColor: Colors.black,
                         color: Colors.greenAccent[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                           children: <Widget>[
                            FloatingActionButton(
                              heroTag: "fab7",
                              elevation: 5,
                              mini: true,
                              backgroundColor: Colors.lightGreen[400],
                              child: Icon(
                                Icons.book,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {
                             //   Navigator.of(context)
                               //     .pushNamed(NotesListScreen.routeName);
                              },
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: 80,
                              child: Text(AppLocalization.of(context)!.getTranslatedValues(notes)!,
                                
                                style: TextStyles.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                          ),

                        ),    
                      ],
                    ),

                   Container(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Card(
                         clipBehavior: Clip.antiAlias,
                         elevation: 10, 
                         shadowColor: Colors.black,
                         color: Colors.greenAccent[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:  Column(
                            children: <Widget>[
                            FloatingActionButton(
                              heroTag: "fab4",
                              elevation: 5,
                              mini: true,
                              backgroundColor: Colors.blue[400],
                              child: Icon(
                                Icons.event,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {
                            //    Navigator.of(context)
                              //      .pushNamed(EventsListScreen.routeName);
                              },
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: 80,
                              child: Text(AppLocalization.of(context)!.getTranslatedValues(events)!,
                               
                                style: TextStyles.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                          ),

                        ),
                        Card(
                         clipBehavior: Clip.antiAlias,
                         elevation: 10, 
                         shadowColor: Colors.black,
                         color: Colors.greenAccent[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                            children: <Widget>[
                            FloatingActionButton(
                              heroTag: "fab6",
                              elevation: 5,
                              mini: true,
                              backgroundColor: Colors.green[500],
                              child: Icon(
                                Icons.accessibility,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () {
                            //    Navigator.of(context)
                             //       .pushNamed(DevotionalScreen.routeName);
                              },
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: 80,
                              child: Text(AppLocalization.of(context)!.getTranslatedValues(devotionals)!,
                               
                                style: TextStyles.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                          ),

                        ),
                        Card(
                         clipBehavior: Clip.antiAlias,
                         elevation: 10, 
                         shadowColor: Colors.black,
                         color: Colors.greenAccent[100],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:  Column(
                          children: <Widget>[
                            FloatingActionButton(
                              heroTag: "fab2",
                              elevation: 5,
                              mini: true,
                              backgroundColor: Colors.yellow[600],
                              child: Icon(
                                Icons.bloodtype,
                                size: 25,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                     
                              },
                            ),
                            Container(height: 5),
                            SizedBox(
                              width: 80,
                              child: Text(AppLocalization.of(context)!.getTranslatedValues(donate)!,
                                 
                                style: TextStyles.caption(context),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                         ),
                          ),

                        ),
  
                      ],
                    ),
                    Container(height: 15),  
                  ],
                ),
              ),
            ),
            
   
  // suggested category        
         
            Row(
                children: [ 
                   Container(
                    child:Align(
                    alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: Text(AppLocalization.of(context)!.getTranslatedValues(suggestedCategoryforyou)!,
                          style: TextStyles.headline(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: "serif",
                            fontSize: 17,
                          ),
                        ),
                      ),
                     ),

                  ),
                  Spacer(),
                  InkWell(
                        onTap: () {
                    //         Navigator.of(context).pushNamed(CategoriesScreen.routeName);
                        },
                        child: Container(
                          child:Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Text(AppLocalization.of(context)!.getTranslatedValues(viewAll)!,
                              textAlign: TextAlign.end,
                              style: TextStyles.headline(context).copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                                fontFamily: "serif",
                                fontSize: 15,
                                
                              ),
                            ),
                          ),
                          ),
                          
                        )
                    )
                ], 
            ),
    //        HomeCategorySlider(homeProvider!.data['categories'] as List<Categories>?),
         

// suggested video

          Container(height: 15), 
             Row(
                children: [ 
                   Container(
                    child:Align(
                    alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: Text(AppLocalization.of(context)!.getTranslatedValues(suggestedVideosforyou)!,
                          style: TextStyles.headline(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: "serif",
                            fontSize: 17,
                          ),
                        ),
                      ),
                     ),

                  ),
                  Spacer(),
                  InkWell(
                        onTap: () {
                  //         Navigator.of(context).pushNamed(VideoScreen.routeName);
                        },
                        child: Container(
                          child:Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Text(AppLocalization.of(context)!.getTranslatedValues(viewAll)!,
                              textAlign: TextAlign.end,
                              style: TextStyles.headline(context).copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                                fontFamily: "serif",
                                fontSize: 15,
                                
                              ),
                            ),
                          ),
                          ),
                          
                        )
                    )


                ], 
            ),
  //          HomeSlider(homeProvider!.data['sliders'] as List<Media>?),

// suggested audio

          Container(height: 15),
        
               Row(
                children: [ 
                   Container(
                    child:Align(
                    alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: Text(AppLocalization.of(context)!.getTranslatedValues(suggestedAudioforyou)!,
                          style: TextStyles.headline(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: "serif",
                            fontSize: 17,
                          ),
                        ),
                      ),
                     ),

                  ),
                  Spacer(),
                   InkWell(
                        onTap: () {
                       //     Navigator.of(context).pushNamed(AudioScreen.routeName);
                        },
                        child: Container(
                          child:Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Text(AppLocalization.of(context)!.getTranslatedValues(viewAll)!,
                              textAlign: TextAlign.end,
                              style: TextStyles.headline(context).copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                                fontFamily: "serif",
                                fontSize: 15,
                                
                              ),
                            ),
                          ),
                          ),
                          
                        )
                    )


                ], 
            ),
    //        HomeSlider(homeProvider!.data['slider_audio'] as List<Media>?),

 
             
            Container(height: 15),
          ],
        ),
      //),
      );
  }
}
 