
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../HymnsRepository.dart';
import '../models/HymnsModel.dart'; 

abstract class HymnsState {}

class HymnsInitial extends HymnsState {}
class HymnsFetchInProgress extends HymnsState {}
class HymnsSuccess extends HymnsState { 
 final List<HymnsModel> hymnsList;
  HymnsSuccess(this.hymnsList);  
}

class HymnsFailure extends HymnsState {
  final String errorMessage;

  HymnsFailure(this.errorMessage);
}

class HymnsLoading extends HymnsState {}

class HymnsCubit extends Cubit<HymnsState> {
  final HymnsRepository _hymnsRepository;
  HymnsCubit(this._hymnsRepository) : super(HymnsInitial());
 
   void getHymns(
      {required String query, 
      required int hymnsId,
      required String userId}) async {
    emit(HymnsFetchInProgress());
    _hymnsRepository
        .getHymns(query: query,hymnsId: hymnsId, userId: userId)
        .then(
          (val) => emit(HymnsSuccess(val)),
        )
        .catchError((e) {
      emit(HymnsFailure(e.toString()));
    });
  }

 
}
