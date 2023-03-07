import 'DevotionalsException.dart';
import 'DevotionalsRemoteDataSource.dart';
import 'models/DevotionalsModel.dart'; 

class DevotionalsRepository {
  static final DevotionalsRepository _devotionalsRepository = DevotionalsRepository._internal();
  late DevotionalsRemoteDataSource _devotionalsRemoteDataSource;

  factory DevotionalsRepository() {
    _devotionalsRepository._devotionalsRemoteDataSource = DevotionalsRemoteDataSource();

    return _devotionalsRepository;
  }

  DevotionalsRepository._internal();
 
 Future<List<DevotionalsModel>> getDevotionals(
      {
        required String devotionalDate,
      required String userId}) async {
    try {
      
      List<DevotionalsModel> categoryList = [];
      List result = await _devotionalsRemoteDataSource.fetchItems( 
        devotionalDate: devotionalDate, userId: userId,
      );
      categoryList = result
          .map((devotionals) => DevotionalsModel.fromJson(Map.from(devotionals)))
          .toList();
       
      return categoryList;
    } catch (e) {
      throw DevotionalsException(errorMessageCode: e.toString());
    }
  } 

}
