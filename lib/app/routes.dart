import 'package:bevicschurch/ui/screens/chat/searchPageScreen.dart';
import 'package:bevicschurch/ui/screens/chat/widget/groupInfoScreen.dart';
import 'package:bevicschurch/ui/screens/dashboard/HomeSliderVideo.dart';
import 'package:bevicschurch/ui/screens/dashboard/homeCategoryAll.dart';
import 'package:bevicschurch/ui/screens/mediaAudioPlayer/audioPlayerScreen.dart';
import 'package:bevicschurch/ui/screens/introSliderScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bevicschurch/ui/screens/CaptureImageScreen.dart';
import 'package:bevicschurch/ui/screens/aboutAppScreen.dart';
import 'package:bevicschurch/ui/screens/appSettingsScreen.dart';
import 'package:bevicschurch/ui/screens/auth/otpScreen.dart';
import 'package:bevicschurch/ui/screens/auth/signInScreen.dart';
import 'package:bevicschurch/ui/screens/auth/signUpScreen.dart';
import 'package:bevicschurch/ui/screens/badgesScreen.dart';  
import 'package:bevicschurch/ui/screens/coinHistoryScreen.dart'; 
 

import 'package:bevicschurch/ui/screens/referAndEarnScreen.dart';
import 'package:bevicschurch/ui/screens/rewards/rewardsScreen.dart'; 

import 'package:bevicschurch/ui/screens/splashScreen.dart';
import 'package:bevicschurch/ui/screens/statisticsScreen.dart'; 
import 'package:bevicschurch/ui/screens/wallet/walletScreen.dart';
    
import '../ui/screens/AddPlaylistScreen.dart';
import '../ui/screens/Downloader.dart';
import '../ui/screens/SubscriptionScreen.dart';
import '../ui/screens/VideoPlayer/VideoPlayer.dart';
import '../ui/screens/VideoPlayer/VideoScreen.dart';
import '../ui/screens/audioPlayer/AudioScreen.dart';
import '../ui/screens/audioPlayer/player_page.dart';
import '../ui/screens/bible/BibleScreen.dart';
import '../ui/screens/bible/BibleSearchScreen.dart'; 
import '../ui/screens/bible/ColoredHighightedVerses.dart'; 
import '../ui/screens/chat/ChatHomeScreen.dart';
import '../ui/screens/chat/groupPageDetailsScreen.dart';  
import '../ui/screens/chat/cChat/chatDetailsScreen.dart';
import '../ui/screens/chat/cChat/chatNewAddScreen.dart';
import '../ui/screens/comments/CommentsScreen.dart';
import '../ui/screens/comments/RepliesScreen.dart';
import '../ui/screens/dashboard/HomeCategorySlider.dart';
import '../ui/screens/dashboard/dashboard.dart';
import '../ui/screens/dashboard/homeCategoryAllSingleList.dart';
import '../ui/screens/devotional/DevotionalScreen.dart';
import '../ui/screens/events/EventsListScreen.dart';
import '../ui/screens/events/EventsViewerScreen.dart';
import '../ui/screens/giving/GivingCategoryScreen.dart';
import '../ui/screens/giving/GivingListScreen.dart';
import '../ui/screens/giving/GivingViewerScreen.dart';
import '../ui/screens/hymn/HymnsCategoryScreen.dart';
import '../ui/screens/hymn/HymnsListScreen.dart';
import '../ui/screens/hymn/HymnsViewerScreen.dart';
import '../ui/screens/mediaAudioPlayer/audioCommentScreen.dart';
import '../ui/screens/mediaAudioPlayer/mainAudioPlayerScreen.dart'; 
import '../ui/screens/notes/NewNoteScreen.dart';
import '../ui/screens/notes/NotesEditorScreen.dart';
import '../ui/screens/notes/NotesListScreen.dart'; 

class Routes {
  static const home = "/home";
  static const dashboard = "/";
  static const login = "login";
  static const splash = 'splash';
  static const signUp = "signUp";
  static const introSlider = "introSlider";
  static const selectProfile = "selectProfile";
  static const quiz = "/quiz";
  static const subcategoryAndLevel = "/subcategoryAndLevel";
  static const subCategory = "/subCategory";

  static const referAndEarn = "/referAndEarn";
  static const notification = "/notification";
  static const bookmark = "/bookmark";
  static const bookmarkQuiz = "/bookmarkQuiz";
  static const coinStore = "/coinStore";
  static const rewards = "/rewards";
  static const result = "/result";
  static const selectRoom = "/selectRoom";
  static const category = "/category";
  static const profile = "/profile";
  static const editProfile = "/editProfile";
  static const leaderBoard = "/leaderBoard";
  static const reviewAnswers = "/reviewAnswers";
  static const selfChallenge = "/selfChallenge";
  static const selfChallengeQuestions = "/selfChallengeQuestions";
  static const battleRoomQuiz = "/battleRoomQuiz";
  static const battleRoomFindOpponent = "/battleRoomFindOpponent";

  static const logOut = "/logOut";
  static const trueFalse = "/trueFalse";
  static const multiUserBattleRoomQuiz = "/multiUserBattleRoomQuiz";
  static const multiUserBattleRoomQuizResult = "/multiUserBattleRoomQuizResult";

  static const contest = "/contest";
  static const contestLeaderboard = "/contestLeaderboard";
  static const funAndLearnTitle = "/funAndLearnTitle";
  static const funAndLearn = "funAndLearn";
  static const guessTheWord = "/guessTheWord";
  static const appSettings = "/appSettings";
  static const levels = "/levels";
  static const aboutApp = "/aboutApp";
  static const badges = "/badges";
  static const exams = "/exams";
  static const exam = "/exam";
  static const tournament = "/tournament";
  static const tournamentDetails = "/tournamentDetails";
  static const otpScreen = "/otpScreen";
  static const statistics = "/statistics";
  static const coinHistory = "/coinHistory";
  static const wallet = "/wallet";
  static const captureImage = "/captureImage";
  static const HomeCategory = "/HomeCategory";
  static const HomeVideoSlider = "/HomeSlider";
  static const playPage = "/playerpage";
  static const videoplayer = "/videoplayer";
  static const notes = "/NotesListScreen";

  static const givingHome = "/GivingListScreen"; 
  static const givingCategory = '/GivingCategoryScreen';
  static const givingViwer = '/GivingViewerScreen';

  static const streamingPortrayScreen = "/StreamPortrayScreen"; 
  static const streamingLandScapeScreen = "/StreamingLandScapeScreen"; 

  static const streamingHome = "/StreamingCategoryScreen"; 

  static const hymnsHome = "/HymnsListScreen"; 
  static const newNotes = "/NewNotesScreen";
  static const notesEditor = 'notesEditorScreen';
  static const hymnsCategory = '/hymnsCategoryScreen';
  static const hymnsViwer = '/hymnsViewerScreen';
  static const devotionals = '/devotionalScreen';
  static const eventsViewer = '/eventsViewerScreen';
  static const eventsPage = '/eventsListScreen';
  static const bibleVerseCompare ='bibleVerseCompare';
  static const bibleHome = '/bibleScreen';
  static const bibleVerse = '/bibleVersionsScreen';
  static const coloredHighightedVerses = '/coloredHighightedVerses';
  static const bibleSearch = '/bibleSearchScreen';
  static const audioScreen = '/audioScreen';
  static const subscription = '/subscriptionscreen';
  static const addplaylists = '/addplaylists';
  static const downloader = '/downloader';
  static const videoMain = '/videoscreen';
  static const comments = '/comments';
  static const allCategories = '/allCategories';
  static const homeCategoryAllSingleList ='homeCategoryAllSingleList';
  static const mainVideoPlayer ='mainVideoPlayer';


  static const audioPlayer = '/newAudioPlayer';
  static const mainAudioPlayerScreen = '/mainAudioPlayerScreen';
  static const audioComments = '/audioComments';
  static const videoComments = '/videoComments';
  static const videoCommentsReply = '/videoCommentsReply';

  static const chatHome = '/chatHome';
  static const chatDetail = '/chat';
  static const groupDetails = '/groupDetails';
  static const groupProfile = '/groupProfile';
  static const groupNewMember = '/groupNewMember';
  static const newChat = '/newchat';
  static const groupPageDetail = '/groupPageDetail';
  static const groupInfo = '/groupInfo';
  static const groupSearch = '/groupSearch';

  

  static String currentRoute = splash;

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    //to track current route
    //this will only track pushed route on top of previous route
    currentRoute = routeSettings.name ?? "";
    print("Current Route is $currentRoute");
    switch (routeSettings.name) {
      case splash:
        return CupertinoPageRoute(builder: (context) => SplashScreen());
 
      case login:
        return CupertinoPageRoute(builder: (context) => SignInScreen());
      case signUp:
        return CupertinoPageRoute(builder: (context) => SignUpScreen());
      case otpScreen:
        return OtpScreen.route(routeSettings);
     case dashboard:
        return Dashboard.route(routeSettings); 
  case introSlider:
        return CupertinoPageRoute(builder: (context) => IntroSliderScreen());
      case wallet:
        return WalletScreen.route(routeSettings);
      case captureImage:
        return CupertinoPageRoute<String?>(
            builder: (context) => CaptureImageScreen());
   
      case rewards:
        return RewardsScreen.route(routeSettings);
      case referAndEarn:
        return CupertinoPageRoute(builder: (_) => ReferAndEarnScreen());
 
      case allCategories:
        return HomeCategoryAll.route(routeSettings); 
      case homeCategoryAllSingleList:
        return HomeCategoryAllSingleList.route(routeSettings); 
      case HomeCategory:
        return HomeCategorySlider.route(routeSettings); 
      case HomeVideoSlider:
        return HomeSliderVideo.route(routeSettings); 
    
      case videoMain:
        return VideoScreen.route(routeSettings); 
      case videoplayer:
        return VideoPlayer.route(routeSettings);   
      case playPage:
        return PlayPage.route(routeSettings);  
      case bookmarkQuiz:
 

      case appSettings:
        return AppSettingsScreen.route(routeSettings);

/*       case levels:
        return LevelsScreen.route(routeSettings);  */

      case notes:
        return NotesListScreen.route(routeSettings);

      case newNotes:
        return NewNotesScreen.route(routeSettings);   

      case notesEditor:
        return NotesEditorScreen.route(routeSettings);  


        
     case givingHome:
        return GivingListScreen.route(routeSettings);  

     case givingCategory:
        return GivingCategoryScreen.route(routeSettings); 

     case givingViwer:
        return GivingViewerScreen.route(routeSettings);
 

     case hymnsHome:
        return HymnsListScreen.route(routeSettings);  

     case hymnsCategory:
        return HymnsCategoryScreen.route(routeSettings); 

     case hymnsViwer:
        return HymnsViewerScreen.route(routeSettings);

     case devotionals:
        return DevotionalScreen.route(routeSettings);
 
     case eventsViewer:
        return EventsViewerScreen.route(routeSettings);

     case eventsPage:
        return EventsListScreen.route(routeSettings);
        
     case bibleHome:
        return BibleScreen.route(routeSettings);
 
            
     case coloredHighightedVerses:
        return ColoredHighightedVerses.route(routeSettings);
     
     case bibleSearch:
      return BibleSearchScreen.route(routeSettings);
 
     case audioScreen:
      return AudioScreen.route(routeSettings);
  
      case subscription:
        return SubscriptionScreen.route(routeSettings);  
 
      case addplaylists:
          return CupertinoPageRoute(builder: (context) => AddPlaylistScreen());
      
       case audioComments:
          return CupertinoPageRoute(builder: (context) => AudioCommentScreen());



      case chatHome:
        return ChatHomeScreen.route(routeSettings);
        
      case chatDetail:
        return ChatDetailsScreen.route(routeSettings); 

       case groupPageDetail:
        return GroupPageDetailsScreen.route(routeSettings); 
 

      case groupInfo:
       return GroupInfoScreen.route(routeSettings); 
       
      case groupSearch:
       return SearchPageScreen.route(routeSettings); 
       
      
      case newChat:
        return ChatNewAddScreen.route(routeSettings); 
        
        
      case downloader:
         return Downloader.route(routeSettings); 

      case coinHistory:
        return CoinHistoryScreen.route(routeSettings);

      case aboutApp:
        return CupertinoPageRoute(builder: (context,) => AboutAppScreen()); 
    
     case audioPlayer :
      return AudioPlayerScreen.route(routeSettings);

     case mainAudioPlayerScreen:
      return MainAudioPlayerScreen.route(routeSettings);
 
      case badges:
        return BadgesScreen.route(routeSettings);
  

      case statistics:
        return StatisticsScreen.route(routeSettings);
        
        case videoComments:
        return CommentsScreen.route(routeSettings);  
       
        case videoCommentsReply:
        return RepliesScreen.route(routeSettings); 
  
// 
      default:
        return CupertinoPageRoute(builder: (context) => Scaffold());
    }
  }
}
