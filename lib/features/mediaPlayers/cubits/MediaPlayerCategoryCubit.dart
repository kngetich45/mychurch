import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../MediaPlayerRepository.dart';
import '../models/MediaPlayerCategoryModel.dart'; 

abstract class MediaPlayerCategoryState {}

class MediaPlayerCategoryInitial extends MediaPlayerCategoryState {}

class MediaPlayerCategoryFetchInProgress extends MediaPlayerCategoryState {}

class MediaPlayerCategoryFetchSuccess extends MediaPlayerCategoryState {
  final List<MediaPlayerCategoryModel> mediaPlayerCategoryList;
     MediaPlayerCategoryFetchSuccess(this.mediaPlayerCategoryList);
 
}

class MediaPlayerCategoryFetchFailure extends MediaPlayerCategoryState {
  final String errorMessage;

  MediaPlayerCategoryFetchFailure(this.errorMessage);
}
 
class MediaPlayerCategoryCubit extends Cubit<MediaPlayerCategoryState> {
  final MediaPlayerRepository _mediaPlayerRepository;
  MediaPlayerCategoryCubit(this._mediaPlayerRepository) : super(MediaPlayerCategoryInitial());
 
  void getMediaPlayerCategory(String userId) async {
    emit(MediaPlayerCategoryFetchInProgress());
    _mediaPlayerRepository
        .getdashCategory(userId)
        .then(
          (val) => emit(MediaPlayerCategoryFetchSuccess(val)),
        )
        .catchError((e) {
      emit(MediaPlayerCategoryFetchFailure(e.toString()));
    });
  }
/* 
  void getMediaPlayerAllCategory(String userId) async {
    emit(MediaPlayerCategoryFetchInProgress());
    _mediaPlayerRepository
        .getdashAllCategory(userId)
        .then(
          (val) => emit(MediaPlayerCategoryFetchSuccess(val)),
        )
        .catchError((e) {
      emit(MediaPlayerCategoryFetchFailure(e.toString()));
    });
  } */

  void updateState(MediaPlayerCategoryState updatedState) {
    emit(updatedState);
  }
}