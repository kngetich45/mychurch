import 'dart:async';  
import 'MediaPlayerException.dart';
import 'MediaPlayerRemoteDataSource.dart';
import 'models/MediaPlayerCategoryModel.dart';
import 'models/MediaPlayerModel.dart';  

class MediaPlayerRepository {
  static final MediaPlayerRepository _mediaPlayerRepository = MediaPlayerRepository._internal();
  late MediaPlayerRemoteDataSource _mediaPlayerRemoteDataSource;
   
  factory MediaPlayerRepository() {
    _mediaPlayerRepository._mediaPlayerRemoteDataSource = MediaPlayerRemoteDataSource(); 
    return _mediaPlayerRepository;
  }

    MediaPlayerRepository._internal();
 
  Future<List<MediaPlayerCategoryModel>> getdashCategory(
      String userId) async {
    try {
      List<MediaPlayerCategoryModel> dashCategoryList = [];
      List result =
          await _mediaPlayerRemoteDataSource.getDashboardCategory(userId);
      dashCategoryList = result
          .map((dasCategory) => MediaPlayerCategoryModel.fromJson(Map.from(dasCategory)))
          .toList();
      return dashCategoryList;
    } catch (e) {
      throw MediaPlayerException(errorMessageCode: e.toString());
    }
  } 

  Future<List<MediaPlayerModel>> getVideoDataRepository({required String userId,String? userEmail}) async {
          
    try {
      List<MediaPlayerModel> dashVideoList = [];
      List result =
          await _mediaPlayerRemoteDataSource.fetchVideoData(userId,userEmail);
      dashVideoList = result
          .map((videoCategory) => MediaPlayerModel.fromJson(Map.from(videoCategory)))
          .toList();
      return dashVideoList;
    } catch (e) {
      throw MediaPlayerException(errorMessageCode: e.toString());
    }
  } 

   Future<List<MediaPlayerModel>> getAudioDaraRepository({required String userId,String? userEmail}) async {
          
    try {
      List<MediaPlayerModel> dashVideoList = [];
      List result =
          await _mediaPlayerRemoteDataSource.fetchAudioData(userId,userEmail);
      dashVideoList = result
          .map((videoCategory) => MediaPlayerModel.fromJson(Map.from(videoCategory)))
          .toList();
      return dashVideoList;
    } catch (e) {
      throw MediaPlayerException(errorMessageCode: e.toString());
    }
  } 

  Future<List<MediaPlayerModel>> getDashboardVideosRepository(
      String userId,String? userEmail) async {
          
    try {
      List<MediaPlayerModel> dashVideoList = [];
      List result =
          await _mediaPlayerRemoteDataSource.fetchDashboardVideos(userId,userEmail);
      dashVideoList = result
          .map((videoCategory) => MediaPlayerModel.fromJson(Map.from(videoCategory)))
          .toList();


          
      return dashVideoList;



    } catch (e) {
      throw MediaPlayerException(errorMessageCode: e.toString());
    }
  } 
   Future<List<MediaPlayerModel>> getMediaByCategoryRepository(
      {
        required String? userEmail,
      required String userId,
      required String catId}) async {
    try {
      
      List<MediaPlayerModel> categoryList = [];
      List result = await _mediaPlayerRemoteDataSource.fetchMediabyCategory( 
         userId: userId, userEmail: userEmail, catId:catId
      );
      categoryList = result
          .map((mediaPlayer) => MediaPlayerModel.fromJson(Map.from(mediaPlayer)))
          .toList();
       
      return categoryList;
    } catch (e) {
      throw MediaPlayerException(errorMessageCode: e.toString());
    }
  } 
 Future<List<MediaPlayerModel>> getMediaPlayer(
      {
        required String userEmail,
      required String userId}) async {
    try {
      
      List<MediaPlayerModel> categoryList = [];
      List result = await _mediaPlayerRemoteDataSource.fetchItems( 
         userId: userId, userEmail: userEmail
      );
      categoryList = result
          .map((mediaPlayer) => MediaPlayerModel.fromJson(Map.from(mediaPlayer)))
          .toList();
       
      return categoryList;
    } catch (e) {
      throw MediaPlayerException(errorMessageCode: e.toString());
    }
  } 



   Future<List<MediaPlayerModel>> getMediaLikesCommentsRepository({required String userId,String? userEmail}) async {
          
    try {
      List<MediaPlayerModel> dashVideoList = [];
      List result =
          await _mediaPlayerRemoteDataSource.fetchAudioData(userId,userEmail);
      dashVideoList = result
          .map((videoCategory) => MediaPlayerModel.fromJson(Map.from(videoCategory)))
          .toList();
      return dashVideoList;
    } catch (e) {
      throw MediaPlayerException(errorMessageCode: e.toString());
    }
  } 
 
}
