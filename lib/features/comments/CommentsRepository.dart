import 'CommentsException.dart';
import 'CommentsRemoteDataSource.dart';
import 'models/CommentsModel.dart'; 

class CommentsRepository {
  static final CommentsRepository _commentsRepository = CommentsRepository._internal();
  late CommentsRemoteDataSource _commentsRemoteDataSource;

  factory CommentsRepository() {
    _commentsRepository._commentsRemoteDataSource = CommentsRemoteDataSource();

    return _commentsRepository;
  }

  CommentsRepository._internal();
 
 Future<List<CommentsModel>> getMakeCommentsRepository(
      {
      required String media,
      required String userId,
      required String? userEmail,
      required String content
      }) async {
    try {
      
      List<CommentsModel> categoryList = [];
      List result = await _commentsRemoteDataSource.fetchMakeComments( 
        media: media, userId: userId,userEmail: userEmail, content: content
      );
      categoryList = result
          .map((comments) => CommentsModel.fromJson(Map.from(comments)))
          .toList();
       
      return categoryList;
    } catch (e) {
      throw CommentsException(errorMessageCode: e.toString());
    }
  } 

 Future<List<CommentsModel>> getCommentsRepository(
      {
      required String mediaId,
      required String userId,
      required String? userEmail,
      required String comentsId
      }) async {
    try {
      
      List<CommentsModel> categoryList = [];
      List result = await _commentsRemoteDataSource.fetchComments( 
        mediaId: mediaId, userId: userId,userEmail: userEmail, comentsId: comentsId
      );
      categoryList = result
          .map((comments) => CommentsModel.fromJson(Map.from(comments)))
          .toList();
       
      return categoryList;
    } catch (e) {
      throw CommentsException(errorMessageCode: e.toString());
    }
  } 
}
