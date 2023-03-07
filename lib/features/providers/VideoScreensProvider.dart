/* import 'package:bevicschurch/features/mediaPlayers/models/MediaPlayerModel.dart';
import 'package:bevicschurch/features/profileManagement/models/userProfile.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:dio/dio.dart'; 
import '../models/Userdata.dart';
import '../models/Media.dart';

class VideoScreensModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  UserProfile? userdata;
  List<MediaPlayerModel>? mediaList = [];
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  String apiURL = "";
  int page = 0;

  VideoScreensModel(UserProfile? userdata) {
    this.mediaList = [];
    this.userdata = userdata;
  }

  loadItems() {
    refreshController.requestRefresh();
    page = 0;
    notifyListeners();
    fetchItems();
  }

  loadMoreItems() {
    page = page + 1;
    fetchItems();
  }

  void setItems(List<MediaPlayerModel>? item) {
    mediaList!.clear();
    mediaList = item;
    refreshController.refreshCompleted();
    isError = false;
    notifyListeners();
  }

  void setMoreItems(List<MediaPlayerModel> item) {
    mediaList!.addAll(item);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> fetchItems() async {
    try {
       
      final dio = Dio();
      // Adding an interceptor to enable caching.

      final response = await dio.post(
        ApiUrl.FETCH_MEDIA,
        data: jsonEncode({
          "data": {
            "email": userdata == null ? "null" : userdata!.email,
            "version": "v2",
            "page": page.toString(),
            "media_type": "video"
          }
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        dynamic res = jsonDecode(response.data);
        List<Media>? mediaList = parseSliderMedia(res);
        if (page == 0) {
          setItems(mediaList);
        } else {
          setMoreItems(mediaList!);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setFetchError();
    }
  }

  static List<MediaPlayerModel>? parseSliderMedia(dynamic res) {
    final parsed = res["media"].cast<Map<String, dynamic>>();
    return parsed.map<MediaPlayerModel>((json) => MediaPlayerModel.fromJson(json)).toList();
  }

  setFetchError() {
    if (page == 0) {
      isError = true;
      refreshController.refreshFailed();
      notifyListeners();
    } else {
      refreshController.loadFailed();
      notifyListeners();
    }
  }
}
 */