
import 'package:bevicschurch/features/bible/models/BibleModel.dart';
import 'package:clipboard/clipboard.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../../../database/SQLiteDbProvider.dart';
import '../../../i18n/strings.g.dart';
import '../../../utils/Alerts.dart';
import '../../../utils/StringsUtils.dart';
import '../BibleRepository.dart';
import '../models/BibleVersionsModel.dart';

abstract class BibleState {}

class BibleInitial extends BibleState {}
class BibleFetchInProgress extends BibleState {}
class BibleSuccess extends BibleState { 
 final List<BibleModel> bibleList;
  
  BibleSuccess(this.bibleList);  
}

class BibleFailure extends BibleState {
  final String errorMessage;

  BibleFailure(this.errorMessage);
}

class BibleLoading extends BibleState {}

class BibleCubit extends Cubit<BibleState> { 
  final BibleRepository _bibleRepository;
  BibleCubit(this._bibleRepository) : super(BibleInitial());
  
  List<String> bibleBooks = [];
  List<int> bibleBooksPages = [];
    List<int> bibleFontSizes = [];
  int selectedBookLength =0;
  int selectedChapter =1;
  String selectedBook ="Genesis";
  String selectedVersion ="";
  List<BibleModel> highlightedBibleVerses = [];
  bool isStartHighlight = false;
  int selectedColor= Colors.yellow[500]!.value;
  List<BibleModel> coloredHighlightedBibleVerses= [];
  List<BibleVersionsModel> downloadedBibleList = [];
  int selectedFontSize = 0;
  final _versionPreference = "version_preference";
  final _bookPreference = "book_preference";
  final _chapterPreference = "chapter_preference";
  final _fontPreference = "font_preference";
  final _languagePreference = "language_preference";
   String? language;

   

     getBibleMainData() {
        getDownloadedBibleList();
        bibleBooks = StringsUtils.bibleBooks;
        bibleBooksPages = StringsUtils.bibleBooksTotalChapters;
        bibleFontSizes = StringsUtils.bibleFontSizes;
        _loadUserBiblePreference();
        // initTts();
      }
  void _loadUserBiblePreference() {
    SharedPreferences.getInstance().then((prefs) {
      selectedVersion = prefs.getString(_versionPreference) ?? "";
      selectedBook = prefs.getString(_bookPreference) ?? "Genesis";
      selectedBookLength = bibleBooksPages[bibleBooks.indexOf(selectedBook)];
      selectedChapter = prefs.getInt(_chapterPreference) ?? 1;
      selectedFontSize = prefs.getInt(_fontPreference) ?? 20;
      language = prefs.getString(_languagePreference) ?? null;
  //    notifyListeners();
    });
  }

 void getBible({required String userId}) async {
    
    emit(BibleFetchInProgress());
    _bibleRepository.getBible(userId: userId).then((val) {
      emit(BibleSuccess(val));
    }).catchError((e) {
      emit(BibleFailure(e.toString()));
    });
  }

  
  Future<List<BibleModel>> showCurrentBibleData(int _selectedChapter) async {
    return await SQLiteDbProvider.db.getAllBible(selectedVersion, selectedBook, _selectedChapter);
  }

  unselectedHighlightedVerses(List<BibleModel> highlightedBibleVerses) {
    highlightedBibleVerses = []; 
  }


  colorizeSelectedVerses() async {
    List<BibleModel> _highlightedBibleVerses = highlightedBibleVerses;
    _highlightedBibleVerses.forEach((element) {
      element.color = selectedColor;
      element.date = DateTime.now().millisecondsSinceEpoch;
    });

    coloredHighlightedBibleVerses.addAll(_highlightedBibleVerses);
    await SQLiteDbProvider.db.insertBatchColoredBible(_highlightedBibleVerses);
    highlightedBibleVerses = [];
   // notifyListeners();
    stopHighlight();
  }

   stopHighlight() {
    highlightedBibleVerses = [];
    isStartHighlight = false;
 //   notifyListeners();
  }

  onVerseTapped(BibleModel bible) async {
    if (isBibleColoredHighlighted(bible)) {
      removeColoredVerse(bible);
      return;
    }
    if (isBibleHighlighted(bible)) {
      highlightedBibleVerses.removeWhere(
          (item) => item.id == bible.id && item.version == bible.version);
    } else {
      highlightedBibleVerses.add(bible);
      coloredHighlightedBibleVerses.removeWhere((item) => item.id == bible.id);
    }
    if (highlightedBibleVerses.length == 0) {
      stopHighlight();
    } else {
      startHighlight();
    }
  }
   startHighlight() {
    isStartHighlight = true;
   // notifyListeners();
  }
  removeColoredVerse(BibleModel bible) async {
    coloredHighlightedBibleVerses.removeWhere(
        (item) => item.id == bible.id && item.version == bible.version);
    await SQLiteDbProvider.db.deleteColoredBibleVerse(bible);
   // notifyListeners();
  }


   bool isBibleColoredHighlighted(BibleModel bible) {
    BibleModel? itm = coloredHighlightedBibleVerses.firstWhereOrNull(
        (itm) => itm.id == bible.id && itm.version == bible.version);
    return itm != null;
  }

   bool isBibleHighlighted(BibleModel bible) {
    BibleModel? itm = highlightedBibleVerses.firstWhereOrNull(
        (itm) => itm.id == bible.id && itm.version == bible.version);
    return itm != null;
  }

  
  BibleModel? getBibleColoredHighlightedVerse(BibleModel bible) {
    BibleModel? itm = coloredHighlightedBibleVerses.firstWhereOrNull(
        (itm) => itm.id == bible.id && itm.version == bible.version);
    return itm;
  }

 Future<List<BibleModel>> showCurrentBibleVerseData(int? _verse) async {
    return await SQLiteDbProvider.db.getAllBibleByVerse(
        selectedVersion, selectedBook, selectedChapter, _verse);
  }

   copyHighlightedVerses(BuildContext context) {
    String formattedverses = prepareHighlightedVerses();
    FlutterClipboard.copy(formattedverses)
        .then((value) => Alerts.showToast(context, t.copiedtoclipboard));
    stopHighlight();
  }
String prepareHighlightedVerses() {
    String formattedverses = "";
    formattedverses =
        selectedBook + " Chapter " + selectedChapter.toString() + ": \n";
    highlightedBibleVerses.forEach((element) {
      formattedverses +=
          "Verse " + element.verse.toString() + ": " + element.content! + "\n ";
    });
    return formattedverses;
  }
  shareHightlightedVerses() async {
    String formattedverses = prepareHighlightedVerses();
    await Share.share(
        selectedBook + " Chapter " + selectedChapter.toString() + ": \n",
        subject: formattedverses);
    stopHighlight();
  }

  Future<List<BibleModel>> showColoredHighlightedVerses(
      String query, int color) async {
    if (query != "") {
      return await SQLiteDbProvider.db.searchColoredBibleVerses(query);
    } else if (color != 0) {
      return await SQLiteDbProvider.db.filterColoredVersesByColor(color);
    } else {
      return await SQLiteDbProvider.db.getAllColoredVerses();
    }
  }



   getDownloadedBibleList() async {
    downloadedBibleList = await SQLiteDbProvider.db.getAllBibleVersions();
    if (downloadedBibleList.length != 0 && selectedVersion == "") {
      selectedVersion = downloadedBibleList[0].code!;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(_versionPreference, selectedVersion);
    }
    coloredHighlightedBibleVerses =
        await SQLiteDbProvider.db.getAllColoredVerses();
    print(
        "colored verses = " + coloredHighlightedBibleVerses.length.toString());
   // notifyListeners();
    print(downloadedBibleList.length.toString());
    // downloadedBible = await SQLiteDbProvider.db.getAllBible();
  }

    bool isBibleVersionDownloaded(BibleVersionsModel versions) {
    BibleVersionsModel? itm =
        downloadedBibleList.firstWhereOrNull((itm) => itm.id == versions.id);
    return itm != null;
  }

}
