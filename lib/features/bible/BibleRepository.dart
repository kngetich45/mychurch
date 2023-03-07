  
import 'BibleException.dart'; 
import 'BibleRemoteDataSource.dart';
import 'models/BibleModel.dart';
import 'models/BibleVersionsModel.dart';

class BibleRepository {
  static final BibleRepository _bibleRepository = BibleRepository._internal();
 // late BibleLocalDataSource _bibleLocalDataSource;
 late BibleRemoteDataSource _bibleRemoteDataSource;
 
  factory BibleRepository() {
   // _bibleRepository._bibleLocalDataSource = BibleLocalDataSource();
    _bibleRepository._bibleRemoteDataSource = BibleRemoteDataSource();
    
    return _bibleRepository;
  }

  BibleRepository._internal(); 

    Future<List<BibleModel>> getBible({required String userId}) async { 
      try { 
      List<BibleModel> bibleList = [];
 /*      List result = await _bibleRemoteDataSource.fetchbible(userId: userId
      );
      bibleList = result
          .map((bible) => BibleModel.fromJson(Map.from(bible)))
          .toList(); */
       
      return bibleList;
    } catch (e) {
      throw BibleException(errorMessageCode: e.toString());
    }
  }
 
  Future<List<BibleVersionsModel>> getBibleVerse({required String userId}) async {
    
      try {
      
      List<BibleVersionsModel> bibleList = [];
      List result = await _bibleRemoteDataSource.fetchbibleVerse(userId: userId
      );
      bibleList = result
          .map((bible) => BibleVersionsModel.fromJson(Map.from(bible)))
          .toList();
       
      return bibleList;
    } catch (e) {
      throw BibleException(errorMessageCode: e.toString());
    }
  }

 Future getBibledownloadFile({required String userId, required String bibleSource, required var filePath}) async {
    
      try {
        return await _bibleRemoteDataSource.fetchBibledownloadFile(userId: userId,bibleSource: bibleSource,filePath: filePath
      );
      
    } catch (e) {
      throw BibleException(errorMessageCode: e.toString());
    }
  }

}
