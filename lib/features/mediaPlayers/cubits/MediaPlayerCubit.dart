
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../MediaPlayerRepository.dart';
import '../models/MediaPlayerModel.dart'; 

abstract class MediaPlayerState {}

class MediaPlayerInitial extends MediaPlayerState {}
class MediaPlayerFetchInProgress extends MediaPlayerState {}
class MediaPlayerSuccess extends MediaPlayerState { 
 final List<MediaPlayerModel> mediaPlayerList;
  MediaPlayerSuccess(this.mediaPlayerList);  
}

class MediaPlayerFailure extends MediaPlayerState {
  final String errorMessage;

  MediaPlayerFailure(this.errorMessage);
}

class MediaPlayerLoading extends MediaPlayerState {}

class MediaPlayerCubit extends Cubit<MediaPlayerState> {
  final MediaPlayerRepository _mediaPlayerRepository;
  //final List<MediaPlayerModel> mediaData;
  //final UserProfile userdata;

  MediaPlayerCubit(this._mediaPlayerRepository) : super(MediaPlayerInitial());


   void getVideoPlayerData({required String userId, String? userEmail}) async {
    
    emit(MediaPlayerFetchInProgress());
    _mediaPlayerRepository
        .getVideoDataRepository(userId: userId, userEmail: userEmail)
        .then(
          (val) => emit(MediaPlayerSuccess(val)),
        )
        .catchError((e) {
      emit(MediaPlayerFailure(e.toString()));
    });
  }

 /*    void getAudioPlayerData({required String userId, String? userEmail}) async {
    
    emit(MediaPlayerFetchInProgress());
    _mediaPlayerRepository
        .getAudioDaraRepository(userId: userId, userEmail: userEmail)
        .then(
          (val) => emit(MediaPlayerSuccess(val)),
        )
        .catchError((e) {
      emit(MediaPlayerFailure(e.toString()));
    });
  } */

  void getMediaByCategory({required String userId, required String? userEmail, required String catId}) async {
    emit(MediaPlayerFetchInProgress());
    _mediaPlayerRepository
        .getMediaByCategoryRepository(userId: userId, userEmail: userEmail, catId: catId)
        .then(
          (val) => emit(MediaPlayerSuccess(val)),
        )
        .catchError((e) {
      emit(MediaPlayerFailure(e.toString()));
    });
  }
   
   void getMediaPlayer({required String userId, required String userEmail}) async {
    emit(MediaPlayerFetchInProgress());
    _mediaPlayerRepository
        .getMediaPlayer(userId: userId, userEmail: userEmail)
        .then(
          (val) => emit(MediaPlayerSuccess(val)),
        )
        .catchError((e) {
      emit(MediaPlayerFailure(e.toString()));
    });
  }

  void getDashboardVideos(String userId, String? userEmail) async {
    
    emit(MediaPlayerFetchInProgress());
    _mediaPlayerRepository
        .getDashboardVideosRepository(userId,userEmail)
        .then(
          (val) => emit(MediaPlayerSuccess(val)),
        )
        .catchError((e) {
      emit(MediaPlayerFailure(e.toString()));
    });
  }

  void updateState(MediaPlayerState updatedState) {
    emit(updatedState);
  }
 
    
/* 
  void getMediaLikesCommentsCount({required int? mediaId, required String userId, required String? userEmail}) async {
    emit(MediaPlayerFetchInProgress());
    _mediaPlayerRepository
        .getMediaLikesCommentsRepository(mediaId: mediaId, userId: userId, userEmail: userEmail)
        .then(
          (val) => emit(MediaPlayerSuccess(val)),
        )
        .catchError((e) {
      emit(MediaPlayerFailure(e.toString()));
    });
  } */
 
}
