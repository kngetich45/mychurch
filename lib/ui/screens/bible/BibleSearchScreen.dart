import 'package:bevicschurch/features/bible/models/BibleModel.dart';
import 'package:bevicschurch/features/providers/BibleProvider.dart';
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart'; 
import '../../../features/bible/BibleRepository.dart';
import '../../../features/bible/cubits/BibleCubit.dart';
import '../../../features/bible/cubits/BibleVerseCubit.dart';
import '../../../features/bible/models/BibleVersionsModel.dart';
import '../../../utils/StringsUtils.dart';
import '../../../i18n/strings.g.dart'; 
import '../../styles/TextStyles.dart'; 
import 'package:select_dialog/select_dialog.dart'; 
import 'widgets/BibleVersesTileSearch.dart';

class BibleSearchScreen extends StatefulWidget {
  static const routeName = "/biblesearchscreen"; 
const BibleSearchScreen({Key? key}) : super(key: key);
  @override
 
    State<BibleSearchScreen> createState() =>_BibleSearchScreenRouteState();

       static Route<BibleSearchScreen> route(RouteSettings routeSettings) { 

        return CupertinoPageRoute(
        builder: (_) => MultiProvider(
                providers: [ BlocProvider<BibleCubit>(
                      create: (_) => BibleCubit(BibleRepository())),
                      BlocProvider<BibleVerseCubit>(
                      create: (_) => BibleVerseCubit(BibleRepository())),
                      ChangeNotifierProvider<BibleProvider>(
                          create: (context) => BibleProvider(),
                        ),
                      
                      ],
              child: BibleSearchScreen(),
            ));
  } 
}

class _BibleSearchScreenRouteState extends State<BibleSearchScreen> {
  bool finishLoading = true;
  bool showClear = false;
  final TextEditingController inputController = new TextEditingController();
  Future<List<BibleModel>>? bibleSearch;
  String query = "";
  List<String>? books;
  String? version = "";
  String book = "";
  int limit = 20;
  late PersistentBottomSheetController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool oldTestament = true;
  bool? newTestament = true;
 
  @override
  void initState() {
    books = StringsUtils.bibleBooks;
    version = Provider.of<BibleProvider>(context, listen: false).selectedVersion;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    BibleProvider bibleProvider = Provider.of<BibleProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: TextField(
          maxLines: 1,
          controller: inputController,
          style: new TextStyle(color: Colors.white, fontSize: 18),
          keyboardType: TextInputType.text,
          onSubmitted: (term) {
            query = term;
            if (term == "") return;
            setState(() {
              finishLoading = false;
            });
            bibleSearch = bibleProvider.searchBible(
                term, version, book, oldTestament, newTestament, limit);
          },
          onChanged: (term) {
            setState(() {
              showClear = (term.length > 2);
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: t.searchbible,
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.white54),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          showClear
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    inputController.clear();
                    showClear = false;
                    setState(() {});
                  },
                )
              : Container(),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: buildBody(context)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            height: 50,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    t.filtersearchoptions,
                    textAlign: TextAlign.center,
                    style: TextStyles.subhead(context).copyWith(),
                  ),
                ),
                Container(
                  width: 12,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      showSearchFilterOptions(context, bibleProvider);
                    },
                    icon: Icon(Icons.filter_list),
                    iconSize: 30,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return FutureBuilder<List<BibleModel>>(
      future: bibleSearch,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return buildContent(context, t.nosearchresult, t.nosearchresulthint);
        } else if (snapshot.hasData) {
          List<BibleModel>? currentBibleList = snapshot.data;
          if (currentBibleList == null || currentBibleList.length == 0) {
            return buildContent(
                context, t.nosearchresult, t.nosearchresulthint);
          }
          return ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: currentBibleList.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return BibleVersesTileSearch(
                  object: currentBibleList[index],
                  query: query,
                );
              });
        } else {
          if (finishLoading) {
            return buildContent(context, t.searchbible, t.narrowdownsearch);
          }
          return Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget buildContent(BuildContext context, String title, String text) {
    return Align(
      child: Container(
        width: 300,
        height: 300,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title,
                style: TextStyles.headline(context).copyWith(
                    color: Colors.grey[500], fontWeight: FontWeight.bold)),
            Container(height: 5),
            Text(text,
                textAlign: TextAlign.center,
                style: TextStyles.medium(context)
                    .copyWith(color: Colors.grey[500])),
          ],
        ),
      ),
      alignment: Alignment.center,
    );
  }

  void showSearchFilterOptions(context, BibleProvider bibleProvider) {
    _controller = _scaffoldKey.currentState!.showBottomSheet((BuildContext bc) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
          top: BorderSide(color: Colors.red, width: 5, style: BorderStyle.solid),
         // left: BorderSide(color: Colors.green, width: 10, style: BorderStyle.solid),
      ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                t.searchbibleversion,
                style: TextStyles.subhead(context)
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                version!,
                style: TextStyles.subhead(context).copyWith(fontSize: 14),
              ),
              onTap: () {
                showBibleVersionsMenuSheet(context, bibleProvider);
              },
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(
                t.searchbiblebook,
                style: TextStyles.subhead(context)
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                book,
                style: TextStyles.subhead(context).copyWith(fontSize: 14),
              ),
              onTap: () {
                SelectDialog.showModal<String>(
                  context,
                  searchBoxDecoration: InputDecoration(labelText: t.search),
                  label: t.setBibleBook,
                  itemBuilder: (context, item, isSelected) {
                    return Container(
                      height: 50,
                      child: ListTile(
                        isThreeLine: false,
                        selected: isSelected,
                        trailing: isSelected
                            ? Icon(Icons.check)
                            : Container(
                                height: 0,
                                width: 0,
                              ),
                        title: Text(
                          item,
                          style: TextStyles.subhead(context)
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  },
                  selectedValue: book,
                  items: books,
                  onChange: (String selected) {
                    _controller.setState!(() {
                      book = selected;

                      oldTestament = false;
                      newTestament = false;
                    });
                  },
                );
              },
            ),
            ListTile(
              leading: Checkbox(
                  activeColor: primaryColor,
                  value: oldTestament,
                  onChanged: (val) {
                    setState(() {
                      newTestament = val;
                      book = "";
                    });
                  }),
              title: Text(t.oldtestament),
              onTap: () {
                _controller.setState!(() {
                  oldTestament = !oldTestament;
                  book = "";
                });
              },
            ),
            ListTile(
              leading: Checkbox(
                  activeColor: primaryColor,
                  value: newTestament,
                  onChanged: (val) {
                    setState(() {
                      newTestament = val;
                      book = "";
                    });
                  }),
              title: Text(t.newtestament),
              onTap: () {
                _controller.setState!(() {
                  newTestament = !newTestament!;
                  book = "";
                });
              },
            ),
            ListTile(
              title: Text(t.limitresults + " - $limit"),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.red[700],
                    inactiveTrackColor: Colors.red[100],
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 4.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    thumbColor: Colors.redAccent,
                    overlayColor: Colors.red.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                    tickMarkShape: RoundSliderTickMarkShape(),
                    activeTickMarkColor: Colors.red[700],
                    inactiveTickMarkColor: Colors.red[100],
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor: Colors.redAccent,
                    valueIndicatorTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child: Slider(
                    value: limit.toDouble(),
                    min: 10,
                    max: 100,
                    divisions: 10,
                    label: '$limit',
                    onChanged: (value) {
                      print(value);
                      _controller.setState!(
                        () {
                          limit = (value).floor();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: 12,
            ),
            Container(
              width: double.infinity,
              height: 40,
              child: TextButton(
                child:
                    Text(t.setfilters, style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (query != "") {
                    _controller.setState!(() {
                      bibleSearch = bibleProvider.searchBible(query, version, book,
                          oldTestament, newTestament, limit);
                    });
                  }
                },
              ),
            ),
            Container(
              height: 15,
            ),
          ],
        ),
      );
    });
  }

  void showBibleVersionsMenuSheet(context, BibleProvider bibleProvider) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: bibleProvider.downloadedBibleList.length,
              itemBuilder: (BuildContext ctxt, int index) {
                BibleVersionsModel versions = bibleProvider.downloadedBibleList[index];
                return ListTile(
                  title: Text(versions.name!),
                  onTap: () {
                    Navigator.of(context).pop();
                    _controller.setState!(() {
                      version = versions.code;
                    });
                  },
                  trailing: version == versions.code
                      ? Icon(
                          Icons.check,
                          color: primaryColor,
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                );
              },
            ),
          );
        });
  }
}
