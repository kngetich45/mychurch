 
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes.dart';
import '../../../features/bible/BibleRepository.dart';
import '../../../features/bible/cubits/BibleCubit.dart';
import '../../../features/bible/models/BibleModel.dart';
import '../../../features/bible/models/BibleVersionsModel.dart';
import '../../../features/providers/BibleProvider.dart';
import '../../../i18n/strings.g.dart';
import '../../styles/TextStyles.dart'; 
import 'package:flutter/material.dart';
//import '../widgets/BibleTTSPlayer.dart';
import 'package:select_dialog/select_dialog.dart';
import '../../styles/colors.dart';
//import '../../styles/Colors.dart';
import 'package:provider/provider.dart';
 import 'widgets/BibleTTSPlayer.dart';
import 'widgets/BibleVersesTile.dart';
 import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class BibleViewScreen extends StatefulWidget {
  BibleViewScreen();

  @override
  //BibleViewScreenRouteState createState() => new BibleViewScreenRouteState();
  State<BibleViewScreen> createState() =>BibleViewScreenRouteState();

       static Route<BibleViewScreen> route(RouteSettings routeSettings) { 

        return CupertinoPageRoute(
        builder: (_) => MultiProvider(
                providers: [
                  BlocProvider<BibleCubit>(
                    create: (_) => BibleCubit(BibleRepository())),
                   ChangeNotifierProvider<BibleProvider>(
                     create: (context) => BibleProvider(),
                    ),
                ], 
              child: BibleViewScreen(),
            ));
  }
  
}

class BibleViewScreenRouteState extends State<BibleViewScreen> {
  Future<List<BibleModel>>? bibleLoader;
  PageController? controller;
  int itemCount = 0;
  List<BibleModel>? currentBibleList = [];
  BibleProvider? bibleProvider;

  @override
  void initState() { 
    itemCount =
        Provider.of<BibleProvider>(context, listen: false).selectedBookLength;
    bibleLoader = Provider.of<BibleProvider>(context, listen: false)
        .showCurrentBibleData(
            Provider.of<BibleProvider>(context, listen: false).selectedChapter);
    controller = PageController(
      initialPage:
          Provider.of<BibleProvider>(context, listen: false).selectedChapter - 1,
    );

    super.initState();
  }

  void _openDialog(BuildContext _context, String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: Container(height: 230, child: content),
          actions: [
            TextButton(
              child: Text(t.cancel),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text(t.set),
              onPressed: () {
                bibleProvider!.colorizeSelectedVerses();
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
       Future.delayed(Duration.zero, () {
         //   context.read<BibleCubit>().unselectedHighlightedVerses( 
         //     context.read<BibleCubit>().highlightedBibleVerses
         // );
    });
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bibleProvider = Provider.of<BibleProvider>(context);
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                      style: TextStyles.subhead(context)
                          .copyWith(fontWeight: FontWeight.w500),
                      children: <TextSpan>[
                        TextSpan(
                          text: bibleProvider!.selectedBook +
                              t.chapter +
                              Provider.of<BibleProvider>(context, listen: false)
                                  .selectedChapter
                                  .toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        TextSpan(
                          text: " (" + bibleProvider!.selectedVersion! + ")",
                          style: TextStyle(fontSize: 13),
                        )
                      ]),
                ),
                Container(
                  width: 130,
                  height: 2,
                  color: primaryColor,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: PageView.builder(
            onPageChanged: (page) {
              print("page changed to = " + page.toString());
              setState(() {
                Provider.of<BibleProvider>(context, listen: false)
                    .selectedChapter = page + 1;
              });
              bibleLoader = Provider.of<BibleProvider>(context, listen: false)
                  .showCurrentBibleData(page + 1);
            },
            itemCount: bibleProvider!.selectedBookLength,
            scrollDirection: Axis.horizontal,
            reverse: false,
            controller: controller,
            pageSnapping: true,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder<List<BibleModel>>(
                future: bibleLoader,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    currentBibleList = snapshot.data;
                    return ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                        itemCount: currentBibleList!.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return BibleVersesTile(
                            object: currentBibleList![index],
                            showCompare:
                                bibleProvider!.downloadedBibleList.length > 1,
                          );
                        });
                  }
                },
              );
            },
          ),
        ),
        Consumer<BibleProvider>(
          builder: (context, bibleProvider, child) {
            if (!bibleProvider.isStartHighlight) {
              return Container();
            }
            return Container(
              width: double.infinity,
              height: 60,
              child: Row(
                children: <Widget>[
                  
                  Container(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          child: Icon(Icons.color_lens,
                              color: Colors.yellow[900], size: 25.0),
                          onTap: () {
                            _openDialog(
                              context,
                              t.selectColor,
                              MaterialColorPicker(
                                selectedColor: Color(bibleProvider.selectedColor),
                                allowShades: false,
                                onMainColorChange: (color) {
                                  bibleProvider.selectedColor = color!.value;
                                  print(Color(color.value));
                                },
                              ),
                            );
                          }),
                          Text("Select Color")
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Icon(Icons.content_copy,
                            color: Colors.purple, size: 23.0),
                        onTap: () {
                          bibleProvider.copyHighlightedVerses(context);
                        },
                      ),
                      Container(width: 20),
                       Text("Copy")
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child:
                            Icon(Icons.share, color: Colors.lightBlue, size: 25.0),
                        onTap: () {
                          bibleProvider.shareHightlightedVerses();
                        },
                      ),
                       Text("Share")
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Icon(Icons.cancel, color: Colors.red, size: 25.0),
                        onTap: () {
                          bibleProvider.stopHighlight();
                        },
                      ),
                      
                       Text("Clear")
                    ],
                  ),
                  Container(width: 20),
                ],
              ),
            );
          },
        ),
        BibleTTSPlayer(),
        Container(
           
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 50,
          width: double.infinity,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Container( 
                      height: double.infinity,
                      child: Material(
                        color: Color.fromARGB(255, 236, 235, 235), 
                        borderRadius: BorderRadius.circular(28),
                        borderOnForeground: true, 
                        child: InkWell(
                          onTap: () {
                            if (Provider.of<BibleProvider>(context, listen: false)
                                    .selectedChapter >
                                1) {
                              int currentitm = Provider.of<BibleProvider>(context,
                                          listen: false)
                                      .selectedChapter -
                                  2;
                              controller!.jumpToPage(currentitm);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            
                            child: Icon(
                              Icons.chevron_left,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.center,
                      child: buildProgress(context, bibleProvider!),
                    )),
                    Container(
                      height: double.infinity,
                      child: Material(
                        color: Color.fromARGB(255, 236, 235, 235), 
                        borderRadius: BorderRadius.circular(28),
                        borderOnForeground: true, 
                        child: InkWell(
                          onTap: () {
                            if (Provider.of<BibleProvider>(context, listen: false)
                                    .selectedChapter <
                                itemCount) {
                              controller!.jumpToPage(Provider.of<BibleProvider>(
                                      context,
                                      listen: false)
                                  .selectedChapter);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.chevron_right,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    showBibleOptionsMenuSheet(context, bibleProvider);
                  },
                  icon: Icon(Icons.menu),
                  iconSize: 30,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildProgress(BuildContext context, BibleProvider bibleProvider) {
    double progress =
        bibleProvider.selectedChapter * (1 / bibleProvider.selectedBookLength);
    Widget widget = Container(
      height: 4,
      width: 130,
      child: LinearProgressIndicator(
        value: progress,
        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        backgroundColor: Colors.grey[300],
      ),
    );
    return widget;
  }

  void showBibleOptionsMenuSheet(context, BibleProvider? bibleProvider) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Wrap(
              
              children: <Widget>[
                
                ListTile(
                  
                  leading: Icon(Icons.visibility),
                  title: Text(
                    t.switchbibleversion,
                    style: TextStyles.subhead(context)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    bibleProvider!.selectedVersion!,
                    style: TextStyles.subhead(context).copyWith(fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    showBibleVersionsMenuSheet(context, bibleProvider);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.swap_horiz),
                  title: Text(
                    t.switchbiblebook,
                    style: TextStyles.subhead(context)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    bibleProvider.selectedBook,
                    style: TextStyles.subhead(context).copyWith(fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    SelectDialog.showModal<String>(
                      context,
                      searchBoxDecoration: InputDecoration(labelText: t.search),
                      label: t.switchbiblebook,
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
                      selectedValue: bibleProvider.selectedBook,
                      items: bibleProvider.bibleBooks,
                      onChange: (String selected) {
                        controller!.jumpToPage(0);
                        Provider.of<BibleProvider>(context, listen: false)
                            .selectedChapter = 1;
                        bibleProvider.setCurrentSelectedBibleBook(selected);
                        bibleLoader =
                            Provider.of<BibleProvider>(context, listen: false)
                                .showCurrentBibleData(1);
                      },
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.format_list_numbered),
                  title: Text(
                    t.gotosearch,
                    style: TextStyles.subhead(context)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    t.chapter + " " + bibleProvider.selectedChapter.toString(),
                    style: TextStyles.subhead(context).copyWith(fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    SelectDialog.showModal<int>(
                      context,
                      searchBoxDecoration: InputDecoration(labelText: t.search),
                      label: t.gotosearch,
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
                              t.chapter + " " + item.toString(),
                              style: TextStyles.subhead(context)
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      },
                      selectedValue: bibleProvider.selectedChapter,
                      items: List.generate(
                          bibleProvider.selectedBookLength, (index) => index + 1),
                      onChange: (int selected) {
                        controller!.jumpToPage(selected);
                        Provider.of<BibleProvider>(context, listen: false)
                            .selectedChapter = selected;
                        bibleProvider.setCurrentSelectedBibleChapter(selected);
                      },
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.format_size),
                  title: Text(
                    t.changefontsize,
                    style: TextStyles.subhead(context)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    t.font + " - " + bibleProvider.selectedFontSize.toString(),
                    style: TextStyles.subhead(context).copyWith(fontSize: 14),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();

                    SelectDialog.showModal<int>(
                      context,
                      //searchBoxDecoration: InputDecoration(labelText: "search"),
                      label: t.changefontsize,
                      showSearchBox: false,
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
                              t.font + " - " + item.toString(),
                              style: TextStyles.subhead(context)
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      },
                      selectedValue: bibleProvider.selectedFontSize,
                      items: bibleProvider.bibleFontSizes,
                      onChange: (int selected) {
                        bibleProvider.setCurrentSelectedFontSize(selected);
                      },
                    );
                  },
                ),
                /* ListTile(
                  leading: Icon(Icons.keyboard_voice),
                  title: Text(
                    t.readchapter,
                    style: TextStyles.subhead(context)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    bibleModel.readBibleChapter(currentBibleList);
                  },
                ),*/
                ListTile(
                  leading: Icon(Icons.highlight),
                  title: Text(
                    t.showhighlightedverse,
                    style: TextStyles.subhead(context)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushNamed(Routes.coloredHighightedVerses);
                  },
                ),
              ],
            ),
          );
        });
  }

  void showBibleVersionsMenuSheet(context, BibleProvider? bibleProvider) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: bibleProvider!.downloadedBibleList.length + 1,
              itemBuilder: (BuildContext ctxt, int index) {
                if (index == bibleProvider.downloadedBibleList.length) {
                  return Container(
                    width: 180,
                    height: 40,
                    child: TextButton(
                      child: Text(t.downloadmoreversions,
                          style: TextStyle(color: Colors.white)),
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushNamed(Routes.bibleVerse);
                      },
                    ),
                  );
                }
                BibleVersionsModel versions = bibleProvider.downloadedBibleList[index];
                return ListTile(
                  title: Text(versions.name!),
                  onTap: () {
                    Navigator.of(context).pop();
                    bibleProvider.setCurrentSelectedBibleVersion(versions.code!);
                    bibleLoader =
                        Provider.of<BibleProvider>(context, listen: false)
                            .showCurrentBibleData(
                                Provider.of<BibleProvider>(context, listen: false)
                                    .selectedChapter);
                  },
                  trailing: bibleProvider.selectedVersion == versions.code
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
   