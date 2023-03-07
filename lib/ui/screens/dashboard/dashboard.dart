import 'dart:io'; 
import 'package:bevicschurch/features/ads/interstitialAdCubit.dart';
import 'package:bevicschurch/features/badges/cubits/badgesCubit.dart';
import 'package:bevicschurch/features/profileManagement/cubits/updateUserDetailsCubit.dart';
import 'package:bevicschurch/features/profileManagement/profileManagementLocalDataSource.dart';
import 'package:bevicschurch/features/profileManagement/profileManagementRepository.dart';
import 'package:bevicschurch/ui/screens/dashboard/widgets/drawerScreen.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart'; 
import 'package:bevicschurch/i18n/strings.g.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:bevicschurch/app/appLocalization.dart';
import 'package:bevicschurch/app/routes.dart';
import 'package:bevicschurch/features/auth/authRepository.dart';
import 'package:bevicschurch/features/auth/cubits/authCubit.dart';
import 'package:bevicschurch/features/auth/cubits/referAndEarnCubit.dart';
import 'package:bevicschurch/features/profileManagement/cubits/userDetailsCubit.dart';
import 'package:bevicschurch/features/profileManagement/models/userProfile.dart';
import 'package:bevicschurch/features/systemConfig/cubits/systemConfigCubit.dart'; 
import 'package:bevicschurch/ui/widgets/circularProgressContainner.dart';
import 'package:bevicschurch/ui/widgets/errorContainer.dart';
import 'package:bevicschurch/ui/widgets/pageBackgroundGradientContainer.dart';
import 'package:bevicschurch/utils/errorMessageKeys.dart';
import 'package:bevicschurch/utils/stringLabels.dart';
import 'package:bevicschurch/utils/uiUtils.dart';
import 'package:path_provider/path_provider.dart'; 
import '../../../features/mediaPlayers/MediaPlayerRepository.dart';
import '../../../features/mediaPlayers/cubits/MediaAudioPlayerCubit.dart';
import '../../../features/mediaPlayers/cubits/MediaPlayerCategoryCubit.dart';
import '../../../features/mediaPlayers/cubits/MediaPlayerCubit.dart'; 
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../features/providers/AudioPlayerProvider.dart';
import '../../../features/providers/SubscriptionProvider.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/uiUtils.dart';
import '../../widgets/circularProgressContainner.dart';
import '../../widgets/errorContainer.dart';
 
import '../../styles/TextStyles.dart';
import '../../styles/colors.dart'; 
import 'HomeCategorySlider.dart';
import 'HomeSliderVideo.dart';
import 'HomeSliderAudio.dart';

class Dashboard extends StatefulWidget {
   Dashboard({
    Key? key,
  }) : super(key: key);  
 
   //final DashboardCategoryModel dashboardCategoryModel;

 // Dashboard({required this.dashboardCategoryModel}); */

  @override
  _DashboardState createState() => _DashboardState();
  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (context) => MultiProvider(
              providers: [
                BlocProvider<ReferAndEarnCubit>(
                  create: (_) => ReferAndEarnCubit(AuthRepository()),
                ),
                BlocProvider<UpdateUserDetailCubit>(
                  create: (_) =>
                      UpdateUserDetailCubit(ProfileManagementRepository()),
                ),
                BlocProvider<MediaPlayerCategoryCubit>(
                  create: (_) =>
                      MediaPlayerCategoryCubit(MediaPlayerRepository()),
                ),
                BlocProvider<MediaPlayerCubit>(
                  create: (_) => MediaPlayerCubit(MediaPlayerRepository()),
                ),
                BlocProvider<MediaAudioPlayerCubit>(
                  create: (_) => MediaAudioPlayerCubit(MediaPlayerRepository()),
                ),
                ChangeNotifierProvider<AudioPlayerProvider>(
                          create: (_) => AudioPlayerProvider(),
               ),
               ChangeNotifierProvider<SubscriptionProvider>(
                          create: (_) => SubscriptionProvider(),
               ),
              ],
              child: Dashboard(),
            ));
  }
}

class _DashboardState extends State<Dashboard>  with TickerProviderStateMixin, WidgetsBindingObserver {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final controller = ScrollController();

  bool? dragUP;
  int currentMenu = 1;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() { 
    initAnimations(); 
    _initGetData();
    _initLocalNotification();
    checkForUpdates();
    setupInteractedMessage();
    createAds();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void initAnimations() {

  
  }
   void _initGetData(){
     Future.delayed(Duration.zero, () {
            context.read<MediaPlayerCategoryCubit>().getMediaPlayerCategory(
            context.read<UserDetailsCubit>().getUserId(),
          );
    });
   }
  void createAds() {
    Future.delayed(Duration.zero, () {
      context.read<InterstitialAdCubit>().createInterstitialAd(context);
    });
  }

 /*  void showAppUnderMaintenanceDialog() {
    Future.delayed(Duration.zero, () {
      if (context.read<SystemConfigCubit>().appUnderMaintenance()) {
        
    });
  } */

   void _initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payLoad) {
      print("For ios version <= 9 notification will be shown here");
    });

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _onTapLocalNotification);
    _requestPermissionsForIos();
  }

  Future<void> _requestPermissionsForIos() async {
    if (Platform.isIOS) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions();
    }
  }
 
  late bool showUpdateContainer = false;

  void checkForUpdates() async {
    await Future.delayed(Duration.zero);
    if (context.read<SystemConfigCubit>().isForceUpdateEnable()) {
      try {
        bool forceUpdate = await UiUtils.forceUpdate(
            context.read<SystemConfigCubit>().getAppVersion());

        if (forceUpdate) {
          setState(() {
            showUpdateContainer = true;
          });
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> setupInteractedMessage() async {
    //
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .requestPermission(announcement: true, provisional: true);
    }

    //FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    // handle background notification
    FirebaseMessaging.onBackgroundMessage(UiUtils.onBackgroundMessage);
    //handle foreground notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Notification arrives : $message");
      var data = message.data;

      var title = data['title'].toString();
      var body = data['body'].toString();
      var type = data['type'].toString();

      var image = data['image'];

      //if notification type is badges then update badges in cubit list
      if (type == "badges") {
        String badgeType = data['badge_type'];
        Future.delayed(Duration.zero, () {
          context.read<BadgesCubit>().unlockBadge(badgeType);
        });
      }

      if (type == "payment_request") {
        Future.delayed(Duration.zero, () {
          context.read<UserDetailsCubit>().updateCoins(
                addCoin: true,
                coins: int.parse(data['coins'].toString()),
              );
        });
      }

      //payload is some data you want to pass in local notification
      image != null
          ? generateImageNotification(title, body, image, type, type)
          : generateSimpleNotification(title, body, type);
    });
  }

 

  Future<void> _onTapLocalNotification(NotificationResponse? payload) async {
  //
    String type = payload!.payload ?? "";
    if (type == "badges") {
      Navigator.of(context).pushNamed(Routes.badges);
    } else if (type == "category") {
      Navigator.of(context).pushNamed(
        Routes.category,
      );
    } else if (type == "payment_request") {
      Navigator.of(context).pushNamed(Routes.wallet);
    }
  }

  Future<void> generateImageNotification(String title, String msg, String image, String payloads, String type) async {
    var largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    var bigPicturePath = await _downloadAndSaveFile(image, 'bigPicture');
    var bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        hideExpandedLargeIcon: true,
        contentTitle: title,
        htmlFormatContentTitle: true,
        summaryText: msg,
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'com.bevics.church', //channel id
      'ilovemychurch', //channel name
      channelDescription: 'ilovemychurch',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: bigPictureStyleInformation,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, msg, platformChannelSpecifics, payload: payloads);
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  // notification on foreground
  Future<void> generateSimpleNotification( String title, String body, String payloads) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'com.bevics.church', //channel id
        'ilovemychurch', //channel name
        channelDescription: 'ilovemychurch',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
        const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payloads);
  }

 

  @override
  void dispose() {
    ProfileManagementLocalDataSource.updateReversedCoins(0);
  
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    //show you left the game
    if (state == AppLifecycleState.resumed) {
      UiUtils.needToUpdateCoinsLocally(context);
    } else {
      ProfileManagementLocalDataSource.updateReversedCoins(0);
    }
  }
    Widget showLiveImage() {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(Routes.streamingHome);
        }, 
        child: Container(

           transformAlignment: Alignment.bottomCenter,
          child: Lottie.asset("assets/animations/live.json",
          height: MediaQuery.of(context).size.height * .25,
          width: MediaQuery.of(context).size.width * 3),

        )
      ),
       
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBarPadding = MediaQuery.of(context).padding.top;
  
    return Scaffold(
       
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          title: Text("I Love My Church"),
           leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.sort,
                  size:32,
                  color: Colors.white, // Change Custom Drawer Icon Color
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
            actions: <Widget>[
              Align(
             //  alignment: Alignment.topRight,
               child: Padding(
                padding: const EdgeInsets.all(8.0),
              //  padding: EdgeInsets.only(top: statusBarPadding), streamingHome
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                     Container(
                      width: 42,
                      height: 38, 
                      child:  showLiveImage() , 
                    ),  
                   
                    
                    SizedBox(
                      width: 12.5,
                    ),
                    Container(
                      width: 45,
                      height: 40,
                   /*    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        boxShadow: [
                          UiUtils.buildBoxShadow(
                              offset: Offset(5, 5), blurRadius: 10.0),
                        ],
                        borderRadius: BorderRadius.circular(15.0),
                      ), */
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.leaderBoard);
                        },
                        icon: Icon(
                            Icons.leaderboard,
                            color: Colors.white,
                            size: 28,
                          ),
                        /* icon: SvgPicture.asset(
                          UiUtils.getImagePath("leaderboard_dark.svg"),
                          color: Colors.white,
                        ), */
                      ),
                    ),
                    
                   /*  SizedBox(
                      width: 12.5,
                    ),
                    Container(
                      width: 45,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        boxShadow: [
                          UiUtils.buildBoxShadow(
                              offset: Offset(5, 5), blurRadius: 10.0),
                        ],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              )),
                              context: context,
                              builder: (context) {
                                return MenuBottomSheetContainer();
                              });
                        },
                        icon: Icon(
                          Icons.menu,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ), */
                   /*  SizedBox(
                      width: MediaQuery.of(context).size.width * (0.085),
                    ), */
                  ],
                ),
            ),
          )
      ], 
    ),
       drawer: BuildDrawer(),
      
      body: BlocConsumer<UserDetailsCubit, UserDetailsState>(
        listener: (context, state) {
          if (state is UserDetailsFetchSuccess) {
        

            if (state.userProfile.name!.isEmpty) {
              
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
          if (state is UserDetailsFetchInProgress ||
              state is UserDetailsInitial) {
            return Center(
              child: Container( 
                  child: CircularProgressContainer(
                    useWhiteLoader: false,
                  ),
                ),
            );
           
          }
          if (state is UserDetailsFetchFailure) {
            return Center(
            child: ErrorContainer(
              showBackButton: true,
              errorMessageColor: Theme.of(context).primaryColor,
              errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                convertErrorCodeToLanguageKey(state.errorMessage)
              ),
              onTapRetry: () {
                  context.read<UserDetailsCubit>().fetchUserDetails(
                      context.read<AuthCubit>().getUserFirebaseId());
                },
              showErrorImage: true),
          );
             
          }

          UserProfile userProfile =
              (state as UserDetailsFetchSuccess).userProfile;
          if (userProfile.status == "0") {
            return Container(
               child:  ErrorContainer(
                showBackButton: true,
                errorMessage: AppLocalization.of(context)!
                    .getTranslatedValues(accountDeactivatedKey)!,
                onTapRetry: () {
                  context.read<UserDetailsCubit>().fetchUserDetails(
                      context.read<AuthCubit>().getUserFirebaseId());
                },
                showErrorImage: true,
                errorMessageColor: Theme.of(context).primaryColor,
              )
            );
          }
           return Stack(
              children: [
                PageBackgroundGradientContainer(),
                _buildMainCategoryContainer(statusBarPadding), 
               
               
              ],
            );
          
        },
      ),
    );
  }
 

  Widget _buildMainCategoryContainer(double statusBarPadding) {

    return Container(
      
      decoration: BoxDecoration(color: Colors.white),
       
        child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 0.5, color: Colors.grey),
              Container( 
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.27,
                            
                            decoration: BoxDecoration(
                              color: primaryColor,

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
                                            mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(vertical: 10),
                                                  child: Text("Test Your Faith",
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white
                                                  ),),
                                              ),
          
                                            Container(height: 10,),
              
                                                 Align(
                                                  alignment: Alignment.centerLeft,
                                                   child: Row(
                                                   
                                                    children: [
                                                      Icon(
                                                        
                                                            Icons.done,
                                                            color: Colors.white,
                                                            size: 14.0,
                                                          ), 
                                                              Container(width: 5), 
                                                              
                                                              Text("Total received coins: "+context.read<UserDetailsCubit>().getCoins().toString()+"",
                                                              textAlign: TextAlign.left,
                                                              style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.white
                                                    
                                                                                                 ),),
                                                           
                                                                                                 ],),
                                                 ) ,
                                              
                                             
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
                                                Text("Subscription fee: 0 coin",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white,
                                                  
                                                  
                                                ),),
          
                                                ],) 
                                              
                                              ),
                                              Container(height: 10,),
                                          
          
                                            ],
                                          )

                                          
                                        
                                        ],
                                      ), 
                                           
                                           
                                           
                                      Container(
                                           margin: EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                   Container(width: 20,),
                                                    ElevatedButton(
                                                          onPressed: (){
                                                           // Navigator.of(context).pushNamed(Routes.home);
                                                          },
                                                          child: const Text("Prayer Request", style: TextStyle(
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

                                                       
                                                            ElevatedButton(
                                                          onPressed: (){
                                                            Navigator.of(context).pushNamed(Routes.home);
                                                          },
                                                          child: const Text("Play Now", style: TextStyle(
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

                                              

                                                ]

                                              ),
                                        ) 
                                    
                                      
          
                                  ],
                                ),
                              )
                
                        ), 
          
                      

      
                  Expanded(
                          flex: 1,
                          child:_buildmainContainer()
                  ),
                    
           

          ],

        ),

    );
        

  } 

 Widget _buildmainContainer()
 
 {
  return  FadingEdgeScrollView.fromSingleChildScrollView(
              
              child: SingleChildScrollView(
                controller: controller,
                child: Container(
                  child: Column( 
                        children: [ 
                              Card(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
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
                                            Navigator.of(context)
                                             .pushNamed(Routes.bibleHome);
                                            },
                                            
                                          ),
                                          Container(height: 5),
                                          SizedBox(
                                            width: 80,
                                            child: Text("Bible",
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
                                             Navigator.of(context)
                                                .pushNamed(Routes.hymnsCategory);
                                            },
                                          ),
                                          Container(height: 5),
                                          SizedBox(
                                            width: 80,
                                            child: Text("Hymns",
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
                                            backgroundColor: Colors.cyan[400],
                                            child: Icon(
                                              Icons.book,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                             Navigator.of(context)
                                               .pushReplacementNamed(Routes.notes);
                                            },
                                          ),
                                          Container(height: 5),
                                          SizedBox(
                                            width: 80,
                                            child: Text("Notes",
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
                                            backgroundColor: Colors.blueGrey[600],
                                            child: Icon(
                                              Icons.event,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                             Navigator.of(context)
                                                 .pushNamed(Routes.eventsPage);
                                            },
                                          ),
                                          Container(height: 5),
                                          SizedBox(
                                            width: 80,
                                            child: Text("Events",
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
 
                                                 /*          Navigator.pushReplacement(
                                                                      context,
                                                                      FadeInRoute(
                                                                        scaffoldKey,
                                                                        Routes.devotionals,
                                                                      ),
                                                                    ); */
                                                                                                                  
                                            Navigator.of(context)
                                                  .pushNamed(Routes.devotionals); 
                                                  
                                            },
                                          ),
                                          Container(height: 5),
                                          SizedBox(
                                            width: 80,
                                            child: Text("Sermons",
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
                                            backgroundColor: Colors.amberAccent[600],
                                            child: Icon(
                                              Icons.bloodtype,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                            onPressed: () async {
                                            Navigator.of(context)
                                                  .pushNamed(Routes.givingCategory); 
                                            
                                            },
                                          ),
                                          Container(height: 5),
                                          SizedBox(
                                            width: 80,
                                            child: Text("Payments",
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
                                            heroTag: "fab12",
                                            elevation: 5,
                                            mini: true,
                                            backgroundColor: Colors.blue[400],
                                            child: Icon(
                                              Icons.video_library,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(Routes.videoMain);
                                         
                                            },
                                          ),
                                          Container(height: 5),
                                          SizedBox(
                                            width: 80,
                                            child: Text("Videos",
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
                                            heroTag: "fab61",
                                            elevation: 5,
                                            mini: true,
                                            backgroundColor: Colors.red[500],
                                            child: Icon(
                                              Icons.audiotrack,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                             Navigator.of(context)
                                                  .pushNamed(Routes.mainAudioPlayerScreen);
                                            },
                                          ),
                                          Container(height: 5),
                                          SizedBox(
                                            width: 80,
                                            child: Text("Audio",
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
                                            heroTag: "fab21",
                                            elevation: 5,
                                            mini: true,
                                            backgroundColor: Colors.green[600],
                                            child: Icon(
                                              Icons.whatsapp,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                            onPressed: () async {
                                               
                                                context.read<UserDetailsCubit>().getUserIsPremium() == "0" ?
                                                      showDialog<String>(
                                                                  context: context,
                                                                  builder: (BuildContext context) => AlertDialog(
                                                                    title: const Text('Premium Subscriptions'),
                                                                    content: const Text('You have free membership plan, Buy premium plan to send a message'),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(context, 'Cancel'),
                                                                        child: const Text('Cancel'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          Navigator.pop(context, 'ok');
                                                                          Navigator.of(context).pushReplacementNamed(Routes.givingCategory); 
                                                                          
                                                                        },
                                                                        child: const Text('Subscribe',style: TextStyle(color: Colors.red),),
                                                                      ),
                                                                    ],
                                                                  ),
                                                      )
                                                      :

                                                  Navigator.of(context).pushNamed(Routes.chatHome);
                                            
                                            },
                                          ),
                                          Container(height: 5),
                                          SizedBox(
                                            width: 80,
                                            child: Text("Chat",
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
                                 
                                  ],
                                ),
                                ),
                              ),
                              
                      // Suggested Category
                      //  
                            Card(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                                elevation: 0.00,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                                child: Column(
                                children: <Widget>[ 
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                    
                                          Container(
                                            color: Theme.of(context).backgroundColor,
                                            child:Align(
                                            alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                                            
                                                child: Text(t.suggestedCategoryforyou,
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
                                                 Navigator.of(context).pushNamed(Routes.allCategories);
                                                },
                                                child: Container(
                                                  child:Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                                    child: Text(t.viewAll,
                                                    // t.viewAll,
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
                                            ),
                                            
                                          ],
                                        ), 
                                        
                                         HomeCategorySlider()  
                                      ],
                                    ),
                                  ),
                                ),
                           
                      
              
              // Suggested videos
                      
                              Card(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                                elevation: 0.00,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                                child: Column(
                                children: <Widget>[ 
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                    
                                          Container(
                                            color: Theme.of(context).backgroundColor,
                                            child:Align(
                                            alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                                            
                                                child: Text(t.suggestedVideosforyou,
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
                                                  
                                                 Navigator.of(context).pushNamed(Routes.videoMain);
                                                },
                                                child: Container(
                                                  child:Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                                    child: Text(t.viewAll,
                                                    // t.viewAll,
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
                                            ),
                                            
                                          ],
                                        ), 
                                        
                                         HomeSliderVideo()  
                                      ],
                                    ),
                                  ),
                                ),
                          
                          
                      
                        
                    
              // Suggested Audio
                             Card(
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                                elevation: 0.00,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                                child: Column(
                                children: <Widget>[ 
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                    
                                          Container(
                                            color: Theme.of(context).backgroundColor,
                                            child:Align(
                                            alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                                            
                                                child: Text(t.suggestedAudioforyou,
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
                                                //  Navigator.of(context).pushNamed(Routes.audioScreen);
                                                       Navigator.of(context).pushNamed(Routes.mainAudioPlayerScreen);
                                                },
                                                child: Container(
                                                  child:Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                                    child: Text(t.viewAll,
                                                    // t.viewAll,
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
                                            ),
                                            
                                          ],
                                        ), 
                                        
                                         HomeSliderAudio()  
                                      ],
                                    ),
                                  ),
                                ),
                          
                                      
                          
                       ] )
                 
                  ),
              ),
              );
   
  
 }



 
}
