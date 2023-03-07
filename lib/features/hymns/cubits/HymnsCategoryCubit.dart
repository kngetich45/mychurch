 
import 'package:flutter_bloc/flutter_bloc.dart';  
import '../HymnsRepository.dart';
import '../models/HymnsCategoryModel.dart';

abstract class HymnsCategoryState {}

class HymnsCategoryInitial extends HymnsCategoryState {}
class HymnsCategoryFetchInProgress extends HymnsCategoryState {}
class HymnsCategorySuccess extends HymnsCategoryState { 
      
  final List<HymnsCategoryModel> hymnsCategoryList;

  HymnsCategorySuccess(this.hymnsCategoryList);
}

class HymnsCategoryFailure extends HymnsCategoryState {
  final String errorMessage;

  HymnsCategoryFailure(this.errorMessage);
}

class HymnsCategoryLoading extends HymnsCategoryState {}

class HymnsCategoryCubit extends Cubit<HymnsCategoryState> { 
  
  final HymnsRepository _hymnsRepository;
  HymnsCategoryCubit(this._hymnsRepository) : super(HymnsCategoryInitial());

  getHymnsCategory({
  required String userId}
  ) async {
    
    emit(HymnsCategoryFetchInProgress()); 
    _hymnsRepository.getHymnsCategory(
      userId: userId, 
    ).then((val) {
      emit(HymnsCategorySuccess(val));
    }).catchError((e) {
      emit(HymnsCategoryFailure(e.toString()));
    });
  } 
}
 