 
import 'package:bevicschurch/features/profileManagement/models/userProfile.dart';
import 'package:flutter/material.dart'; 
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;  
import '../../app/routes.dart'; 
import '../../utils/apiBodyParameterLabels.dart';
import '../../utils/apiUtils.dart';
import '../../utils/constants.dart';  
import '../mediaPlayers/models/MediaPlayerModel.dart'; 

class MediaPlayerProvider with ChangeNotifier {
  int? commentsCount = 0;
  int? likesCount = 0;
  bool? isLiked = false;
  MediaPlayerModel? currentMedia;
  UserProfile? userdata; 

  MediaPlayerProvider(UserProfile? userdata, MediaPlayerModel? media ) {
    this.userdata = userdata;
    if (media != null) {
    //  setMediaLikesCommentsCount(media);
    }
  } 
  setMediaLikesCommentsCount(MediaPlayerModel media,String userUid) {
    currentMedia = media;
    print("currentmedia = " + currentMedia!.id.toString());
    commentsCount = media.commentsCount;
    likesCount = media.likesCount;
    isLiked = media.userLiked == null ? false : media.userLiked;
    //notifyListeners();
    updateViewsCount(userUid);
    getMediaLikesCommentsCount(userUid);
  }

  Future<void> getMediaLikesCommentsCount(String userUid) async {
    try {
      /* final body = {
        accessValueKey: accessValue, 
        userIdKey: userId,
        userEmailKey: userEmail,
        "media": currentMedia!.id, 
      }; 

      var data = {
        "media": currentMedia!.id,
        "email": userdata == null ? "null" : userdata!.email,
      };
      print("get_media_count = " + data.toString());
      final response = await http.post(
          Uri.parse(getmediatotallikesandcommentsviews),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        Map<String, dynamic> res = json.decode(response.body);
        commentsCount = int.parse(res['total_comments'].toString());
        likesCount = int.parse(res['total_likes'].toString());
        isLiked = res['isLiked'] == null ? false : res['isLiked'] as bool?;
        notifyListeners();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    } */


        final data = {  
          accessValueKey: accessValue, 
          userIdKey: userUid,
          mediaId: currentMedia!.id.toString(),
          userEmailKey: userdata!.email,
      };
      print("get_media_count = " + data.toString());
      final response = await http.post(
          Uri.parse(getmediatotallikesandcommentsviews),
          //body: jsonEncode({"data": data}));
           body: data, headers: await ApiUtils.getHeaders());
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
        Map<String, dynamic> res = json.decode(response.body);
        commentsCount = int.parse(res['total_comments'].toString());
        likesCount = int.parse(res['total_likes'].toString());
         likesCount = int.parse(res['total_likes'].toString());
        isLiked = res['isLiked'] == null ? false : res['isLiked'] as bool?;
        notifyListeners();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }  
  }

 
   Future<void> updateViewsCount(String userUid) async {
   // var data = {"media": currentMedia!.id};
     final data = {
           accessValueKey: accessValue, 
          userIdKey: userUid,
          mediaId: currentMedia!.id.toString(),
          userEmailKey: userdata!.email,
      };
    print(data.toString());
    try {
      final response = await http.post(
          Uri.parse(updateMediaTotalViews),
          //body: jsonEncode({"data": data}));
           body: data, headers: await ApiUtils.getHeaders());
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }
  }

  Future<void> likePost(String action,String userUid ) async {
    if (userdata == null) {
      return;
    }
    if (action == "like") {
      likesCount = likesCount! + 1;
      isLiked = true;
      notifyListeners();
    } else {
      likesCount = likesCount! - 1;
      isLiked = false;
      notifyListeners();
    } 
   
    try { 
 
 
     final data = {
          accessValueKey: accessValue, 
          userIdKey: userUid,
          mediaId: currentMedia!.id.toString(),
          userEmailKey: userdata!.email,
          "action": action
      };
      print("get_media_count = " + data.toString());
      final response = await http.post(
          Uri.parse(likeunlikemedia),
          //body: jsonEncode({"data": data}));
           body: data, headers: await ApiUtils.getHeaders());
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print(response.body);
       /*  Map<String, dynamic> res = json.decode(response.body);
        commentsCount = int.parse(res['total_comments'].toString());
        likesCount = int.parse(res['total_likes'].toString());
         likesCount = int.parse(res['total_likes'].toString());
        isLiked = res['isLiked'] == null ? false : res['isLiked'] as bool?; */
        notifyListeners();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
    }  

 

  }

  navigatetoCommentsScreen(BuildContext context) async {
    var count = await Navigator.of(context).pushNamed(Routes.videoComments,
      arguments:
       {
        "item": currentMedia,
         "commentCount": commentsCount

      }  
         // CommentsArguement(item: currentMedia, commentCount: commentsCount),
    );
    commentsCount = count as int?;
    notifyListeners();
  }
}
