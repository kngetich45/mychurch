 

import 'package:flutter_bloc/flutter_bloc.dart';  
import '../GivingRepository.dart';
import '../models/GivingCategoryModel.dart';

abstract class GivingCategoryState {}

class GivingCategoryInitial extends GivingCategoryState {}
class GivingCategoryFetchInProgress extends GivingCategoryState {}
class GivingCategorySuccess extends GivingCategoryState { 
      
  final List<GivingCategoryModel> givingCategoryList;

  GivingCategorySuccess(this.givingCategoryList);
}

class GivingCategoryFailure extends GivingCategoryState {
  final String errorMessage;

  GivingCategoryFailure(this.errorMessage);
}

class GivingCategoryLoading extends GivingCategoryState {}

class GivingCategoryCubit extends Cubit<GivingCategoryState> { 
  
  final GivingRepository _givingRepository;
  GivingCategoryCubit(this._givingRepository) : super(GivingCategoryInitial());

  getGivingCategory({
  required String userId}
  ) async {
    
    emit(GivingCategoryFetchInProgress()); 
    _givingRepository.getGivingCategory(
      userId: userId, 
    ).then((val) {
      emit(GivingCategorySuccess(val));
    }).catchError((e) {
      emit(GivingCategoryFailure(e.toString()));
    });
  } 
}
 