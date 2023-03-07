import 'package:assets_audio_player/assets_audio_player.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bevicschurch/app/appLocalization.dart';
import 'package:bevicschurch/app/routes.dart';
import 'package:bevicschurch/features/ads/interstitialAdCubit.dart';
import 'package:bevicschurch/features/ads/rewardedAdCubit.dart';
import 'package:bevicschurch/features/auth/authRepository.dart';
import 'package:bevicschurch/features/auth/cubits/authCubit.dart';
import 'package:bevicschurch/features/badges/badgesRepository.dart';
import 'package:bevicschurch/features/badges/cubits/badgesCubit.dart';  
import 'package:bevicschurch/features/localization/appLocalizationCubit.dart';
import 'package:bevicschurch/features/profileManagement/cubits/userDetailsCubit.dart'; 
import 'package:bevicschurch/features/settings/settingsCubit.dart';
import 'package:bevicschurch/features/profileManagement/profileManagementRepository.dart';
import 'package:bevicschurch/features/settings/settingsLocalDataSource.dart';
import 'package:bevicschurch/features/settings/settingsRepository.dart';
import 'package:bevicschurch/features/statistic/cubits/statisticsCubit.dart';
import 'package:bevicschurch/features/statistic/statisticRepository.dart';
import 'package:bevicschurch/features/systemConfig/cubits/systemConfigCubit.dart';
import 'package:bevicschurch/features/systemConfig/systemConfigRepository.dart'; 
import 'package:bevicschurch/ui/styles/theme/appTheme.dart';
import 'package:bevicschurch/ui/styles/theme/themeCubit.dart';
import 'package:bevicschurch/utils/constants.dart';
import 'package:bevicschurch/utils/uiUtils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:hive_flutter/hive_flutter.dart';
 
import '../features/mediaPlayers/MediaPlayerRepository.dart';
import '../features/mediaPlayers/cubits/MediaPlayerCategoryCubit.dart';
import '../features/mediaPlayers/cubits/MediaPlayerCubit.dart';  
import '../ui/styles/colors.dart'; 

Box? box;

Future<Widget> initializeApp() async {

  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor:  darkPrimaryColor,
       //  statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark
        ));

    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate();
      FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
      FirebaseFirestore.instance.settings = const Settings(
                persistenceEnabled: true,
                cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
              );
  }

  await Hive.initFlutter();
  await Hive.openBox(
      authBox); //auth box for storing all authentication related details
  await Hive.openBox(
      settingsBox); //settings box for storing all settings details
  await Hive.openBox(
      userdetailsBox); //userDetails box for storing all userDetails details
  await Hive.openBox(examBox);
  await Hive.openBox(chatBox);
 // await Hive.openBox(mediaPlayerModelBox);
  //box = await Hive.openBox<MediaPlayerModel>("mediaPlayerModel");
  //Hive.registerAdapter(MediaPlayerModelAdapter());
  

  
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });

 // connectToChat();

  return MyApp();
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return BouncingScrollPhysics();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage(UiUtils.getImagePath("splash_logo.png")), context);
    precacheImage(AssetImage(UiUtils.getImagePath("map_finded.png")), context);
    precacheImage(AssetImage(UiUtils.getImagePath("map_finding.png")), context);
    precacheImage(AssetImage(UiUtils.getImagePath("scratchCardCover.png")), context);

    return MultiBlocProvider(
      //providing global providers
      providers: [
        //Creating cubit/bloc that will be use in whole app or
        //will be use in multiple screens
        BlocProvider<ThemeCubit>(
            create: (_) => ThemeCubit(SettingsLocalDataSource())),
        BlocProvider<SettingsCubit>(
            create: (_) => SettingsCubit(SettingsRepository())),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthRepository())),
        BlocProvider<AppLocalizationCubit>(
            create: (_) => AppLocalizationCubit(SettingsLocalDataSource())),
        BlocProvider<UserDetailsCubit>(
            create: (_) => UserDetailsCubit(ProfileManagementRepository())),
        //bookmark quesitons of quiz zone
 
        //system config
        BlocProvider<SystemConfigCubit>(
            create: (_) => SystemConfigCubit(SystemConfigRepository())),
        //to configure badges
        BlocProvider<BadgesCubit>(
            create: (_) => BadgesCubit(BadgesRepository())),
        //statistic cubit
        BlocProvider<StatisticCubit>(
            create: (_) => StatisticCubit(StatisticRepository())),
        //Interstitial ad cubit
        BlocProvider<InterstitialAdCubit>(create: (_) => InterstitialAdCubit()),
        //Rewarded ad cubit
        BlocProvider<RewardedAdCubit>(create: (_) => RewardedAdCubit()),
        //tournament cubit
   
         BlocProvider<MediaPlayerCubit>(
            create: (_) => MediaPlayerCubit(MediaPlayerRepository())),


         BlocProvider<MediaPlayerCategoryCubit>(
            create: (_) => MediaPlayerCategoryCubit(MediaPlayerRepository())),
 
      ],
      child: Builder(
        builder: (context) {
          //Watching themeCubit means if any change occurs in themeCubit it will rebuild the child
          final currentTheme = context.watch<ThemeCubit>().state.appTheme;
          //

          final currentLanguage =
              context.watch<AppLocalizationCubit>().state.language;

          return MaterialApp(
            builder: (context, widget) {
              return ScrollConfiguration(
                  behavior: GlobalScrollBehavior(), child: widget!);
            },
            locale: currentLanguage,
            theme: appThemeData[currentTheme]!.copyWith(
                textTheme:
                    GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: supporatedLocales.map((languageCode) {
              return UiUtils.getLocaleFromLanguageCode(languageCode);
            }).toList(),
            initialRoute: Routes.splash,
            onGenerateRoute: Routes.onGenerateRouted,
          );
        },
      ),
    );
  }
}
