import 'GivingException.dart';
import 'GivingRemoteDataSource.dart';
import 'models/GivingModel.dart';
import 'models/GivingCategoryModel.dart';

class GivingRepository {
  static final GivingRepository _givingRepository = GivingRepository._internal();
  late GivingRemoteDataSource _givingRemoteDataSource;

  factory GivingRepository() {
    _givingRepository._givingRemoteDataSource = GivingRemoteDataSource();

    return _givingRepository;
  }

  GivingRepository._internal();
 
 Future<List<GivingModel>> getGiving(
      {required String query, 
      required int givingId,
      required String userId}) async {
    try {
      
      List<GivingModel> categoryList = [];
      List result = await _givingRemoteDataSource.fetchItems(
        querys: query,
        givingId: givingId,
        userId: userId,
      );
      categoryList = result
          .map((giving) => GivingModel.fromJson(Map.from(giving)))
          .toList();
       
      return categoryList;
    } catch (e) {
      throw GivingException(errorMessageCode: e.toString());
    }
  }

   Future<List<GivingCategoryModel>> getGivingCategory({ required String userId }) async {
    try { 
      List<GivingCategoryModel> categoryList = [];
      List result = await _givingRemoteDataSource.fetchGivingCategory(userId: userId);
      categoryList = result
          .map((givingCat) => GivingCategoryModel.fromJson(Map.from(givingCat)))
          .toList();
       
      return categoryList;
    } catch (e) {
      throw GivingException(errorMessageCode: e.toString());
    }
  }

}
