import 'package:bevicschurch/features/profileManagement/models/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppsStateManager with ChangeNotifier {
  UserProfile? userdata;
  bool? isUserSeenOnboardingPage = false;
 // ThemeData? _themeData;
  int preferredLanguage = 0;
  bool autoPlayVideos = true;
  //final _themePreference = "theme_preference";
 // final _langPreference = "language_preference";
  final _playPreference = "video_preference";
  int preferredTheme = 0;
  bool isLoadingTheme = true;

  AppsStateManager() {
   // _loadAppSettings(); 
  }
  setAutoPlayVideos(bool checked) async {
    //AppLanguage _preferredLanguage = AppLanguage.values[index];
    autoPlayVideos = checked;

    notifyListeners();
    // Save selected theme into SharedPreferences
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(_playPreference, checked);
  }
  //app theme manager
/*   void _loadAppSettings() {
    SharedPreferences.getInstance().then((prefs) {
      //autoplay videos
      //autoPlayVideos = prefs.getBool(_playPreference) ?? true;
      //load theme
      try {
        preferredTheme = prefs.getInt(_themePreference) ?? 0;
      } catch (e) {
        // quietly pass
      }
     // _themeData = appThemeData[AppTheme.values[preferredTheme]];
      try {
        //load app language
        preferredLanguage = prefs.getInt(_langPreference) ?? 0;
      } catch (e) {
        // quietly pass
      }
      switch (appLanguageData[AppLanguage.values[preferredLanguage]]!['value']) {
        case "en":
          LocaleSettings.setLocale(AppLocale.en);
          break; 

        case "de":
          LocaleSettings.setLocale(AppLocale.en);
          break;
        case "it":
          LocaleSettings.setLocale(AppLocale.en);
          break;
        case "ar":
          LocaleSettings.setLocale(AppLocale.en);
          break;
      }
      isLoadingTheme = false;
      notifyListeners();
    });
  }
 

  //app language setting
  setAppLanguage(int index) async {
    //AppLanguage _preferredLanguage = AppLanguage.values[index];
    preferredLanguage = index;
    switch (appLanguageData[AppLanguage.values[preferredLanguage]]!['value']) {
      case "en":
        LocaleSettings.setLocale(AppLocale.en);
        break;  
      case "de":
        LocaleSettings.setLocale(AppLocale.en);
        break;
      case "it":
        LocaleSettings.setLocale(AppLocale.en);
        break;
      case "ar":
        LocaleSettings.setLocale(AppLocale.en);
        break;
    }
    // Here we notify listeners that theme changed
    // so UI have to be rebuild
    notifyListeners();
    // Save selected theme into SharedPreferences
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt(_langPreference, preferredLanguage);
  } */

  //app language setting

/* 
  getUserSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("user_seen_onboarding_page") != null) {
      isUserSeenOnboardingPage = prefs.getBool("user_seen_onboarding_page");
    }
  }

  setUserSeenOnboardingPage(bool seen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("user_seen_onboarding_page", seen);
  }

  getUserData() async {
    userdata = await SQLiteDbProvider.db.getUserData();
    print("userdata " + userdata.toString());
    notifyListeners();
    if (userdata != null && userdata!.activated == 0) {
      eventBus.fire(UserLoggedInEvent(userdata));
      updateUserToken();
    }
  }

  setUserData(Userdata _userdata) async {
    await SQLiteDbProvider.db.deleteUserData();
    await SQLiteDbProvider.db.insertUser(_userdata);
    this.userdata = _userdata;
    if (userdata != null && userdata!.activated == 0) {
      eventBus.fire(UserLoggedInEvent(userdata));
      updateUserToken();
    }
    notifyListeners();
  }

  unsetUserData() async {
    await SQLiteDbProvider.db.deleteUserData();
    this.userdata = null;
    eventBus.fire(AppEvents.LOGOUT);
    notifyListeners();
  }

  Future<void> updateUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("firebase_token");
    try {
      final dio = Dio();
      // Adding an interceptor to enable caching.

      final response = await dio.post(
        ApiUrl.updateUserSocialFcmToken,
        data: jsonEncode({
          "data": {"email": userdata!.email, "token": token}
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.data);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  } */
}
