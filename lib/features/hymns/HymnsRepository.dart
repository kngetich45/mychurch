import 'HymnsException.dart';
import 'HymnsRemoteDataSource.dart';
import 'models/HymnsModel.dart';
import 'models/HymnsCategoryModel.dart';

class HymnsRepository {
  static final HymnsRepository _hymnsRepository = HymnsRepository._internal();
  late HymnsRemoteDataSource _hymnsRemoteDataSource;

  factory HymnsRepository() {
    _hymnsRepository._hymnsRemoteDataSource = HymnsRemoteDataSource();

    return _hymnsRepository;
  }

  HymnsRepository._internal();
 
 Future<List<HymnsModel>> getHymns(
      {required String query, 
      required int hymnsId,
      required String userId}) async {
    try {
      
      List<HymnsModel> categoryList = [];
      List result = await _hymnsRemoteDataSource.fetchItems(
        querys: query,
        hymnsId: hymnsId,
        userId: userId,
      );
      categoryList = result
          .map((hymns) => HymnsModel.fromJson(Map.from(hymns)))
          .toList();
       
      return categoryList;
    } catch (e) {
      throw HymnsException(errorMessageCode: e.toString());
    }
  }

   Future<List<HymnsCategoryModel>> getHymnsCategory({ required String userId }) async {
    try { 
      List<HymnsCategoryModel> categoryList = [];
      List result = await _hymnsRemoteDataSource.fetchHymnsCategory(userId: userId);
      categoryList = result
          .map((hymnsCat) => HymnsCategoryModel.fromJson(Map.from(hymnsCat)))
          .toList();
        
       
      return categoryList;
    } catch (e) {
      throw HymnsException(errorMessageCode: e.toString());
    }
  }

}
