import 'StreamingException.dart';
import 'StreamingRemoteDataSource.dart'; 
import 'models/StreamingCategoryModel.dart';

class StreamingRadioRepository {
  static final StreamingRadioRepository _streamingRadioRepository = StreamingRadioRepository._internal();
  late StreamingRemoteDataSource _streamingRemoteDataSource;

  factory StreamingRadioRepository() {
    _streamingRadioRepository._streamingRemoteDataSource = StreamingRemoteDataSource();

    return _streamingRadioRepository;
  }

  StreamingRadioRepository._internal();
  

   Future<List<StreamingCategoryModel>> getStreamingCategory({ required String userId }) async {
    try { 
      List<StreamingCategoryModel> categoryList = [];
      List result = await _streamingRemoteDataSource.fetchStreamingCategory(userId: userId);
      categoryList = result
          .map((streamingCat) => StreamingCategoryModel.fromJson(Map.from(streamingCat)))
          .toList();
       
      return categoryList;
    } catch (e) {
      throw StreamingException(errorMessageCode: e.toString());
    }
  }

}
