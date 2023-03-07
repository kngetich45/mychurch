  
import 'package:flutter_bloc/flutter_bloc.dart';   
import '../StreamingRadioRepository.dart';
import '../models/StreamingCategoryModel.dart';

abstract class StreamingCategoryState {}

class StreamingCategoryInitial extends StreamingCategoryState {}
class StreamingCategoryFetchInProgress extends StreamingCategoryState {}
class StreamingCategorySuccess extends StreamingCategoryState { 
      
  final List<StreamingCategoryModel> streamingCategoryList;

  StreamingCategorySuccess(this.streamingCategoryList);
}

class StreamingCategoryFailure extends StreamingCategoryState {
  final String errorMessage;

  StreamingCategoryFailure(this.errorMessage);
}

class StreamingCategoryLoading extends StreamingCategoryState {}

class StreamingCategoryCubit extends Cubit<StreamingCategoryState> { 
  
  final StreamingRadioRepository _streamingRepository;
  StreamingCategoryCubit(this._streamingRepository) : super(StreamingCategoryInitial());

  getStreamingCategory({
  required String userId}
  ) async {
    
    emit(StreamingCategoryFetchInProgress()); 
    _streamingRepository.getStreamingCategory(
      userId: userId, 
    ).then((val) {
      emit(StreamingCategorySuccess(val));
    }).catchError((e) {
      emit(StreamingCategoryFailure(e.toString()));
    });
  } 
}
 