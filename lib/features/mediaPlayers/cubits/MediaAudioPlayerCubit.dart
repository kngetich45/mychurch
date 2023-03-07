
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../MediaPlayerRepository.dart';
import '../models/MediaPlayerModel.dart'; 

abstract class MediaAudioPlayerState {}

class MediaAudioPlayerInitial extends MediaAudioPlayerState {}
class MediaAudioPlayerFetchInProgress extends MediaAudioPlayerState {}
class MediaAudioPlayerSuccess extends MediaAudioPlayerState { 
 final List<MediaPlayerModel> mediaAudioPlayerList;
  MediaAudioPlayerSuccess(this.mediaAudioPlayerList);  
}

class MediaAudioPlayerFailure extends MediaAudioPlayerState {
  final String errorMessage;

  MediaAudioPlayerFailure(this.errorMessage);
}

class MediaAudioPlayerLoading extends MediaAudioPlayerState {}

class MediaAudioPlayerCubit extends Cubit<MediaAudioPlayerState> {
  final MediaPlayerRepository _mediaPlayerRepository;
  //final List<MediaPlayerModel> mediaData;
  //final UserProfile userdata;

  MediaAudioPlayerCubit(this._mediaPlayerRepository) : super(MediaAudioPlayerInitial());

/* 
   void getVideoPlayerData({required String userId, String? userEmail}) async {
    
    emit(MediaAudioPlayerFetchInProgress());
    _mediaPlayerRepository
        .getVideoDataRepository(userId: userId, userEmail: userEmail)
        .then(
          (val) => emit(MediaAudioPlayerSuccess(val)),
        )
        .catchError((e) {
      emit(MediaAudioPlayerFailure(e.toString()));
    });
  } */

    void getAudioPlayerData({required String userId, String? userEmail}) async {
    
    emit(MediaAudioPlayerFetchInProgress());
    _mediaPlayerRepository
        .getAudioDaraRepository(userId: userId, userEmail: userEmail)
        .then(
          (val) => emit(MediaAudioPlayerSuccess(val)),
        )
        .catchError((e) {
      emit(MediaAudioPlayerFailure(e.toString()));
    });
  }

  /* void getMediaByCategory({required String userId, required String? userEmail, required String catId}) async {
    emit(MediaAudioPlayerFetchInProgress());
    _mediaPlayerRepository
        .getMediaByCategoryRepository(userId: userId, userEmail: userEmail, catId: catId)
        .then(
          (val) => emit(MediaAudioPlayerSuccess(val)),
        )
        .catchError((e) {
      emit(MediaAudioPlayerFailure(e.toString()));
    });
  } */
  /*  
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
  } */

  void updateState(MediaAudioPlayerState updatedState) {
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
