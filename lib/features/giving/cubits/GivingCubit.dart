
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../GivingRepository.dart';
import '../models/GivingModel.dart'; 

abstract class GivingState {}

class GivingInitial extends GivingState {}
class GivingFetchInProgress extends GivingState {}
class GivingSuccess extends GivingState { 
 final List<GivingModel> givingList;
  GivingSuccess(this.givingList);  
}

class GivingFailure extends GivingState {
  final String errorMessage;

  GivingFailure(this.errorMessage);
}

class GivingLoading extends GivingState {}

class GivingCubit extends Cubit<GivingState> {
  final GivingRepository _givingRepository;
  GivingCubit(this._givingRepository) : super(GivingInitial());
 
   void getGiving(
      {required String query, 
      required int givingId,
      required String userId}) async {
    emit(GivingFetchInProgress());
    _givingRepository
        .getGiving(query: query,givingId: givingId, userId: userId)
        .then(
          (val) => emit(GivingSuccess(val)),
        )
        .catchError((e) {
      emit(GivingFailure(e.toString()));
    });
  }

 
}
