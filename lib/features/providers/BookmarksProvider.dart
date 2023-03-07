import 'package:bevicschurch/features/profileManagement/models/userProfile.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';  
import '../../database/SQLiteDbProvider.dart';
import '../mediaPlayers/models/MediaPlayerModel.dart';

class BookmarksProvider with ChangeNotifier {
  UserProfile? userdata;
  List<MediaPlayerModel> bookmarksList = [];

  BookmarksProvider() {
    getBookmarks();
  }

  getBookmarks() async {
    bookmarksList = await SQLiteDbProvider.db.getAllMediaBookmarks();
    //bookmarksList.reversed.toList();
    notifyListeners();
    print(bookmarksList.length.toString());
  }

  bookmarkMedia(MediaPlayerModel media) async {
    await SQLiteDbProvider.db.bookmarkMedia(media);
    getBookmarks();
  }

  unBookmarkMedia(MediaPlayerModel media) async {
    await SQLiteDbProvider.db.deleteBookmarkedMedia(media.id);
    getBookmarks();
  }

  bool isMediaBookmarked(MediaPlayerModel? media) {
    MediaPlayerModel? itm = bookmarksList.firstWhereOrNull((itm) => itm.id == media!.id);
    return itm != null;
  }
}
