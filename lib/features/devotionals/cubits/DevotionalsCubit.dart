
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../DevotionalsRepository.dart';
import '../models/DevotionalsModel.dart'; 

abstract class DevotionalsState {}

class DevotionalsInitial extends DevotionalsState {}
class DevotionalsFetchInProgress extends DevotionalsState {}
class DevotionalsSuccess extends DevotionalsState { 
 final List<DevotionalsModel> devotionalsList;
  DevotionalsSuccess(this.devotionalsList);  
}

class DevotionalsFailure extends DevotionalsState {
  final String errorMessage;

  DevotionalsFailure(this.errorMessage);
}

class DevotionalsLoading extends DevotionalsState {}

class DevotionalsCubit extends Cubit<DevotionalsState> {
  final DevotionalsRepository _devotionalsRepository;
  DevotionalsCubit(this._devotionalsRepository) : super(DevotionalsInitial());
 
   void getDevotionals({required String devotionalDate,required String userId}) async {
    emit(DevotionalsFetchInProgress());
    _devotionalsRepository
        .getDevotionals(devotionalDate: devotionalDate,userId: userId)
        .then(
          (val) => emit(DevotionalsSuccess(val)),
        )
        .catchError((e) {
      emit(DevotionalsFailure(e.toString()));
    });
  }

 
}
