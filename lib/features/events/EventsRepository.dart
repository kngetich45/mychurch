import 'EventsException.dart';
import 'EventsRemoteDataSource.dart';
import 'models/EventsModel.dart'; 

class EventsRepository {
  static final EventsRepository _eventsRepository = EventsRepository._internal();
  late EventsRemoteDataSource _eventsRemoteDataSource;

  factory EventsRepository() {
    _eventsRepository._eventsRemoteDataSource = EventsRemoteDataSource();

    return _eventsRepository;
  }

  EventsRepository._internal();
 
 Future<List<EventsModel>> getEvents(
      {
        required String eventDate,
      required String userId}) async {
    try {
      
      List<EventsModel> categoryList = [];
      List result = await _eventsRemoteDataSource.fetchItems( 
        eventDate: eventDate, userId: userId,
      );
      categoryList = result
          .map((events) => EventsModel.fromJson(Map.from(events)))
          .toList();
       
      return categoryList;
    } catch (e) {
      throw EventsException(errorMessageCode: e.toString());
    }
  } 

}
