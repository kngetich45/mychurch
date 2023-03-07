import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import '../hymns/models/HymnsModel.dart';
import '../../database/SQLiteDbProvider.dart';

class HymnsBookmarksModel with ChangeNotifier {
  List<HymnsModel> bookmarksList = [];

  HymnsBookmarksModel() {
    getBookmarks();
  }

  getBookmarks() async {
    bookmarksList = await SQLiteDbProvider.db.getAllBookmarkedHymns();
    notifyListeners();
  }

  bookmarkHymn(HymnsModel hymns) async {
    await SQLiteDbProvider.db.bookmarkHymn(hymns);
    getBookmarks();
  }

  unBookmarkHymn(HymnsModel hymns) async {
    await SQLiteDbProvider.db.deleteBookmarkedHymn(hymns.id);
    getBookmarks();
  }

  bool isHymnBookmarked(HymnsModel hymns) {
    HymnsModel? itm = bookmarksList.firstWhereOrNull((itm) => itm.id == hymns.id);
    return itm != null;
  }

  searchHymns(String term) {
    List<HymnsModel> _items = bookmarksList.where((hymns) {
      return hymns.title!.toLowerCase().contains(term.toLowerCase()) ||
          hymns.content!.toLowerCase().contains(term.toLowerCase());
    }).toList();
    bookmarksList = _items;
    notifyListeners();
  }
}
