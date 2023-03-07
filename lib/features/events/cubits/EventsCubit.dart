
import 'package:flutter_bloc/flutter_bloc.dart'; 
import '../EventsRepository.dart';
import '../models/EventsModel.dart'; 

abstract class EventsState {}

class EventsInitial extends EventsState {}
class EventsFetchInProgress extends EventsState {}
class EventsSuccess extends EventsState { 
 final List<EventsModel> eventsList;
  EventsSuccess(this.eventsList);  
}

class EventsFailure extends EventsState {
  final String errorMessage;

  EventsFailure(this.errorMessage);
}

class EventsLoading extends EventsState {}

class EventsCubit extends Cubit<EventsState> {
  final EventsRepository _eventsRepository;
  EventsCubit(this._eventsRepository) : super(EventsInitial());
 
   void getEvents({required String eventsDate,required String userId}) async {
    emit(EventsFetchInProgress());
    _eventsRepository
        .getEvents(eventDate: eventsDate,userId: userId)
        .then(
          (val) => emit(EventsSuccess(val)),
        )
        .catchError((e) {
      emit(EventsFailure(e.toString()));
    });
  }

 
}
